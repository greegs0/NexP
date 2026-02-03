class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:update, :destroy]

  def index
    limit = params[:limit]&.to_i || 20

    @notifications = current_user.notifications
                                 .includes(:actor, :notifiable)
                                 .recent

    respond_to do |format|
      format.html do
        @notifications = @notifications.page(params[:page]).per(20)
        # Marquer toutes les notifications affichées comme lues
        current_user.notifications.unread.update_all(read: true)
      end
      format.json do
        @notifications = @notifications.limit(limit)
        render json: @notifications.map { |n| notification_json(n) }
      end
    end
  end

  def update
    @notification.mark_as_read!
    redirect_to notifications_path, notice: 'Notification marquée comme lue.'
  end

  def destroy
    @notification.destroy
    redirect_to notifications_path, notice: 'Notification supprimée.'
  end

  def unread_count
    count = current_user.notifications.unread.count
    render json: { count: count }
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to notifications_path, alert: "Cette notification n'existe pas."
  end

  def notification_json(notification)
    data = {
      id: notification.id,
      action: notification.action,
      message: notification.message,
      read: notification.read?,
      actor_name: notification.actor&.display_name,
      actor_initial: notification.actor&.display_name&.first&.upcase,
      time_ago: helpers.time_ago_in_words(notification.created_at),
      created_at: notification.created_at
    }

    # Ajouter les infos du badge si c'est une notification de badge
    if notification.action == 'badge_earned' && notification.notifiable.is_a?(Badge)
      data[:badge_name] = notification.notifiable.name
      data[:badge_description] = notification.notifiable.description
    end

    data
  end
end
