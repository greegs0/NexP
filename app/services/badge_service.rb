class BadgeService
  def self.check_and_award_badges(user)
    new(user).check_and_award_badges
  end

  def initialize(user)
    @user = user
  end

  def check_and_award_badges
    check_level_badges
    check_project_badges
    check_social_badges
    check_activity_badges
  end

  private

  def check_level_badges
    level_badges = {
      'Débutant' => 1,
      'Apprenti' => 5,
      'Intermédiaire' => 10,
      'Avancé' => 20,
      'Expert' => 30,
      'Maître' => 50,
      'Légende' => 100
    }

    level_badges.each do |name, required_level|
      next if @user.level < required_level

      badge = Badge.find_or_create_by(name: name) do |b|
        b.description = "Atteindre le niveau #{required_level}"
        b.xp_required = (required_level - 1) * 100
      end

      award_badge(badge)
    end
  end

  def check_project_badges
    owned_count = @user.owned_projects.count
    participated_count = @user.projects.count

    project_badges = {
      'Premier Projet' => { owned: 1 },
      'Entrepreneur' => { owned: 5 },
      'Chef de Projet' => { owned: 10 },
      'Collaborateur' => { participated: 5 },
      'Team Player' => { participated: 10 },
      'Vétéran' => { total: 20 }
    }

    project_badges.each do |name, requirements|
      should_award = false

      if requirements[:owned] && owned_count >= requirements[:owned]
        should_award = true
      elsif requirements[:participated] && participated_count >= requirements[:participated]
        should_award = true
      elsif requirements[:total] && (owned_count + participated_count) >= requirements[:total]
        should_award = true
      end

      if should_award
        badge = Badge.find_or_create_by(name: name) do |b|
          b.description = "Badge de projet: #{name}"
        end
        award_badge(badge)
      end
    end
  end

  def check_social_badges
    posts_count = @user.posts.count
    comments_count = @user.comments.count
    followers_count = @user.followers.count
    following_count = @user.following.count

    social_badges = {
      'Première Publication' => { posts: 1 },
      'Blogueur' => { posts: 10 },
      'Influenceur' => { posts: 50 },
      'Commentateur' => { comments: 20 },
      'Populaire' => { followers: 10 },
      'Célébrité' => { followers: 50 },
      'Social' => { following: 10 }
    }

    social_badges.each do |name, requirements|
      should_award = false

      if requirements[:posts] && posts_count >= requirements[:posts]
        should_award = true
      elsif requirements[:comments] && comments_count >= requirements[:comments]
        should_award = true
      elsif requirements[:followers] && followers_count >= requirements[:followers]
        should_award = true
      elsif requirements[:following] && following_count >= requirements[:following]
        should_award = true
      end

      if should_award
        badge = Badge.find_or_create_by(name: name) do |b|
          b.description = "Badge social: #{name}"
        end
        award_badge(badge)
      end
    end
  end

  def check_activity_badges
    skills_count = @user.skills.count
    messages_count = @user.sent_messages.count

    activity_badges = {
      'Polyvalent' => { skills: 5 },
      'Expert Multi-Domaines' => { skills: 10 },
      'Communicateur' => { messages: 50 },
      'Bavard' => { messages: 200 }
    }

    activity_badges.each do |name, requirements|
      should_award = false

      if requirements[:skills] && skills_count >= requirements[:skills]
        should_award = true
      elsif requirements[:messages] && messages_count >= requirements[:messages]
        should_award = true
      end

      if should_award
        badge = Badge.find_or_create_by(name: name) do |b|
          b.description = "Badge d'activité: #{name}"
        end
        award_badge(badge)
      end
    end
  end

  def award_badge(badge)
    return if @user.badges.include?(badge)

    @user.user_badges.create(
      badge: badge,
      earned_at: Time.current
    )

    # Créer une notification
    Notification.create(
      user: @user,
      actor: @user,
      notifiable: badge,
      action: 'badge_earned'
    )
  end
end
