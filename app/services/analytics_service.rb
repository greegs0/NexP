class AnalyticsService
  # Statistiques globales de la plateforme
  def self.platform_stats
    Rails.cache.fetch('analytics/platform_stats', expires_in: 1.hour) do
      {
        users: {
          total: User.count,
          active: User.where('updated_at > ?', 7.days.ago).count,
          available: User.available.count,
          new_this_week: User.where('created_at > ?', 7.days.ago).count,
          new_this_month: User.where('created_at > ?', 30.days.ago).count,
          by_level: user_distribution_by_level
        },
        projects: {
          total: Project.count,
          open: Project.where(status: 'open').count,
          in_progress: Project.where(status: 'in_progress').count,
          completed: Project.where(status: 'completed').count,
          public: Project.where(visibility: 'public').count,
          private: Project.where(visibility: 'private').count,
          new_this_week: Project.where('created_at > ?', 7.days.ago).count,
          new_this_month: Project.where('created_at > ?', 30.days.ago).count
        },
        posts: {
          total: Post.count,
          new_this_week: Post.where('created_at > ?', 7.days.ago).count,
          new_this_month: Post.where('created_at > ?', 30.days.ago).count,
          total_likes: Like.count,
          total_comments: Comment.count
        },
        engagement: {
          total_follows: Follow.count,
          total_messages: Message.count,
          total_notifications: Notification.count,
          total_bookmarks: Bookmark.count
        },
        skills: {
          total: Skill.count,
          most_popular: most_popular_skills(10)
        }
      }
    end
  end

  # Statistiques personnelles d'un utilisateur
  def self.user_stats(user)
    Rails.cache.fetch("analytics/user_stats/#{user.id}", expires_in: 5.minutes) do
      {
        profile: {
          level: user.level,
          experience_points: user.experience_points,
          next_level_xp: (user.level * 100),
          xp_to_next_level: (user.level * 100) - user.experience_points,
          progress_percentage: ((user.experience_points % 100) / 100.0 * 100).round
        },
        activity: {
          posts_count: user.posts_count,
          likes_given: user.likes.count,
          likes_received: Like.joins(:post).where(posts: { user_id: user.id }).count,
          comments_made: user.comments.count,
          comments_received: Comment.joins(:post).where(posts: { user_id: user.id }).count
        },
        social: {
          followers_count: user.followers_count,
          following_count: user.following_count,
          bookmarks_count: user.bookmarks_count
        },
        projects: {
          owned_count: user.owned_projects_count,
          participated_count: user.teams.accepted.count,
          total_count: user.owned_projects_count + user.teams.accepted.count,
          by_status: user_projects_by_status(user)
        },
        skills: {
          total_count: user.skills.count,
          by_category: user_skills_by_category(user)
        },
        badges: {
          total_count: user.badges.count,
          recent: user.badges.joins(:user_badges)
                      .where(user_badges: { user_id: user.id })
                      .order('user_badges.earned_at DESC')
                      .limit(5)
                      .pluck(:name, :description)
        },
        timeline: {
          activity_last_30_days: user_activity_timeline(user, 30)
        }
      }
    end
  end

  # Statistiques d'un projet
  def self.project_stats(project)
    Rails.cache.fetch("analytics/project_stats/#{project.id}", expires_in: 10.minutes) do
      {
        overview: {
          current_members_count: project.current_members_count,
          max_members: project.max_members,
          vacancy_percentage: ((project.max_members - project.current_members_count).to_f / project.max_members * 100).round,
          status: project.status,
          visibility: project.visibility,
          messages_count: project.messages_count,
          bookmarks_count: project.bookmarks_count
        },
        skills: {
          required_count: project.skills.count,
          skills_list: project.skills.pluck(:name)
        },
        members: {
          average_level: project.members.average(:level)&.round(1) || 0,
          total_experience: project.members.sum(:experience_points),
          skills_coverage: project_skills_coverage(project)
        },
        timeline: {
          created_at: project.created_at,
          days_since_creation: (Date.today - project.created_at.to_date).to_i,
          start_date: project.start_date,
          end_date: project.end_date,
          deadline: project.deadline
        }
      }
    end
  end

  # Tendances de la plateforme
  def self.trending_data
    Rails.cache.fetch('analytics/trending', expires_in: 30.minutes) do
      {
        trending_skills: trending_skills(7.days.ago),
        trending_projects: trending_projects(10),
        active_users: most_active_users(10),
        rising_stars: rising_star_users(10)
      }
    end
  end

  private

  # Distribution des utilisateurs par niveau
  def self.user_distribution_by_level
    User.group('CASE
      WHEN level BETWEEN 1 AND 10 THEN \'1-10\'
      WHEN level BETWEEN 11 AND 25 THEN \'11-25\'
      WHEN level BETWEEN 26 AND 50 THEN \'26-50\'
      WHEN level BETWEEN 51 AND 75 THEN \'51-75\'
      WHEN level > 75 THEN \'75+\'
    END').count
  end

  # Compétences les plus populaires
  def self.most_popular_skills(limit)
    Skill.joins(:user_skills)
         .select('skills.*, COUNT(user_skills.id) as users_count')
         .group('skills.id')
         .order('users_count DESC')
         .limit(limit)
         .map { |s| { name: s.name, category: s.category, users_count: s.users_count } }
  end

  # Projets de l'utilisateur par statut
  def self.user_projects_by_status(user)
    all_projects = Project.where(id: user.owned_projects.pluck(:id) + user.projects.pluck(:id))
    all_projects.group(:status).count
  end

  # Compétences de l'utilisateur par catégorie
  def self.user_skills_by_category(user)
    user.skills.group(:category).count
  end

  # Timeline d'activité de l'utilisateur
  def self.user_activity_timeline(user, days)
    start_date = days.days.ago.to_date
    end_date = Date.today

    posts_by_day = user.posts.where('created_at >= ?', start_date)
                       .group("DATE(created_at)")
                       .count

    (start_date..end_date).map do |date|
      {
        date: date,
        posts: posts_by_day[date.to_s] || 0
      }
    end
  end

  # Couverture des compétences d'un projet
  def self.project_skills_coverage(project)
    return 0 if project.skills.empty?

    required_skill_ids = project.skills.pluck(:id)
    member_skill_ids = project.members.joins(:skills).pluck('skills.id').uniq

    covered_skills = (required_skill_ids & member_skill_ids).size
    (covered_skills.to_f / required_skill_ids.size * 100).round
  end

  # Compétences en tendance
  def self.trending_skills(since)
    Skill.joins(:user_skills)
         .where('user_skills.created_at >= ?', since)
         .select('skills.*, COUNT(user_skills.id) as recent_additions')
         .group('skills.id')
         .order('recent_additions DESC')
         .limit(10)
         .map { |s| { name: s.name, category: s.category, recent_additions: s.recent_additions } }
  end

  # Projets en tendance
  def self.trending_projects(limit)
    Project.where(visibility: 'public')
           .where('created_at >= ?', 30.days.ago)
           .order(bookmarks_count: :desc, current_members_count: :desc, created_at: :desc)
           .limit(limit)
           .map { |p| { id: p.id, title: p.title, members_count: p.current_members_count, bookmarks_count: p.bookmarks_count } }
  end

  # Utilisateurs les plus actifs
  def self.most_active_users(limit)
    User.where('updated_at >= ?', 7.days.ago)
        .order(experience_points: :desc, posts_count: :desc)
        .limit(limit)
        .map { |u| { id: u.id, username: u.username, level: u.level, posts_count: u.posts_count } }
  end

  # Utilisateurs "rising stars" (plus grande progression récente)
  def self.rising_star_users(limit)
    User.where('created_at >= ?', 30.days.ago)
        .where('experience_points > ?', 100)
        .order(experience_points: :desc)
        .limit(limit)
        .map { |u| { id: u.id, username: u.username, level: u.level, xp: u.experience_points } }
  end
end
