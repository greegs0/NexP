# frozen_string_literal: true

# Service pour préparer les données du dashboard utilisateur
#
# Usage:
#   service = DashboardDataService.new(user)
#   @stats = service.stats
#   @recent_projects = service.recent_projects
#
class DashboardDataService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  # === Stats globales ===

  def stats
    @stats ||= {
      total_skills: user.skills.count,
      total_projects: user.projects.count,
      total_owned_projects: user.owned_projects.count,
      total_badges: user.badges.count
    }
  end

  # === Projets ===

  def recent_projects
    @recent_projects ||= user.projects
      .includes(:owner, :skills)
      .order(created_at: :desc)
      .limit(3)
  end

  def owned_projects
    @owned_projects ||= user.owned_projects
      .includes(:skills, :members)
      .order(created_at: :desc)
      .limit(3)
  end

  def active_projects
    @active_projects ||= user.projects
      .where(status: ['open', 'in_progress'])
      .includes(:owner, :skills, :members)
      .order(updated_at: :desc)
      .limit(4)
  end

  def upcoming_deadlines
    @upcoming_deadlines ||= user.projects
      .where('deadline IS NOT NULL AND deadline >= ? AND deadline <= ?', Date.today, 30.days.from_now)
      .order(:deadline)
      .limit(5)
  end

  # === Skills ===

  def recent_skills
    @recent_skills ||= user.skills
      .order('user_skills.created_at DESC')
      .limit(5)
  end

  # === Notifications ===

  def recent_notifications
    @recent_notifications ||= user.notifications
      .includes(:actor, :notifiable)
      .recent
      .limit(5)
  end

  def unread_notifications_count
    @unread_notifications_count ||= user.notifications.unread.count
  end

  # === Messages ===

  def unread_messages
    @unread_messages ||= user.received_messages
      .where(read_at: nil)
      .includes(:sender)
      .order(created_at: :desc)
      .limit(3)
  end

  def unread_messages_count
    @unread_messages_count ||= user.received_messages.unread.count
  end

  # === Activité ===

  def recent_activity
    @recent_activity ||= begin
      followed_user_ids = user.following.pluck(:id)
      Notification
        .where(user_id: user.id)
        .or(Notification.where(actor_id: followed_user_ids, action: ['project_join', 'follow']))
        .includes(:actor, :notifiable)
        .order(created_at: :desc)
        .limit(5)
    end
  end

  # === Badges ===

  def user_badges
    @user_badges ||= user.badges.limit(6)
  end

  # === XP Progression ===

  def xp_progression
    @xp_progression ||= calculate_xp_progression
  end

  private

  def calculate_xp_progression
    # Simulation de progression XP pour le graphique
    # Dans une vraie app, on stockerait l'historique des XP
    current_xp = user.experience_points
    base_xp = [current_xp - rand(50..150), 0].max

    7.times.map do |i|
      progress = (current_xp - base_xp) * (i + 1) / 7.0
      (base_xp + progress).round
    end
  end
end
