class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @dashboard = DashboardDataService.new(current_user)

    # Stats
    stats = @dashboard.stats
    @total_skills = stats[:total_skills]
    @total_projects = stats[:total_projects]
    @total_owned_projects = stats[:total_owned_projects]
    @total_badges = stats[:total_badges]

    # Projets
    @recent_projects = @dashboard.recent_projects
    @owned_projects = @dashboard.owned_projects
    @active_projects = @dashboard.active_projects
    @upcoming_deadlines = @dashboard.upcoming_deadlines

    # Skills
    @recent_skills = @dashboard.recent_skills

    # Notifications
    @recent_notifications = @dashboard.recent_notifications
    @unread_notifications_count = @dashboard.unread_notifications_count

    # Messages
    @unread_messages = @dashboard.unread_messages
    @unread_messages_count = @dashboard.unread_messages_count

    # Activité et badges
    @recent_activity = @dashboard.recent_activity
    @user_badges = @dashboard.user_badges

    # XP Progression
    @xp_progression = @dashboard.xp_progression
  end
end
