class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    # Stats optimisées
    @total_skills = current_user.skills.count
    @total_projects = current_user.projects.count
    @total_owned_projects = current_user.owned_projects.count
    @total_badges = current_user.badges.count

    # Projets récents avec optimisation N+1
    @recent_projects = current_user.projects
                                   .includes(:owner, :skills)
                                   .order(created_at: :desc)
                                   .limit(3)

    # Projets créés par l'utilisateur
    @owned_projects = current_user.owned_projects
                                  .includes(:skills, :members)
                                  .order(created_at: :desc)
                                  .limit(3)

    # Skills récentes
    @recent_skills = current_user.skills
                                 .order('user_skills.created_at DESC')
                                 .limit(5)

    # === NOUVELLES DONNÉES POUR LE DASHBOARD AMÉLIORÉ ===

    # Notifications récentes (pour le panneau déroulant)
    @recent_notifications = current_user.notifications
                                        .includes(:actor, :notifiable)
                                        .recent
                                        .limit(5)
    @unread_notifications_count = current_user.notifications.unread.count

    # Messages non lus (aperçu conversations)
    @unread_messages = current_user.received_messages
                                   .where(read_at: nil)
                                   .includes(:sender)
                                   .order(created_at: :desc)
                                   .limit(3)
    @unread_messages_count = current_user.received_messages.unread.count

    # Activité récente (actions des personnes suivies et sur mes projets)
    followed_user_ids = current_user.following.pluck(:id)
    @recent_activity = Notification.where(user_id: current_user.id)
                                   .or(Notification.where(actor_id: followed_user_ids, action: ['project_join', 'follow']))
                                   .includes(:actor, :notifiable)
                                   .order(created_at: :desc)
                                   .limit(5)

    # Badges obtenus
    @user_badges = current_user.badges.limit(6)

    # Deadlines à venir (projets avec deadline dans les 30 prochains jours)
    @upcoming_deadlines = current_user.projects
                                      .where('deadline IS NOT NULL AND deadline >= ? AND deadline <= ?', Date.today, 30.days.from_now)
                                      .order(:deadline)
                                      .limit(5)

    # Projets actifs avec statut
    @active_projects = current_user.projects
                                   .where(status: ['open', 'in_progress'])
                                   .includes(:owner, :skills, :members)
                                   .order(updated_at: :desc)
                                   .limit(4)

    # Progression XP (données pour sparkline - derniers 7 jours simulés)
    # Note: Dans une vraie app, on aurait une table xp_history
    @xp_progression = calculate_xp_progression
  end

  private

  def calculate_xp_progression
    # Simulation de progression XP pour le graphique
    # Dans une vraie app, on stockerait l'historique des XP
    current_xp = current_user.experience_points
    base_xp = [current_xp - rand(50..150), 0].max

    7.times.map do |i|
      progress = (current_xp - base_xp) * (i + 1) / 7.0
      (base_xp + progress).round
    end
  end
end
