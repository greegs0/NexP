class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:update, :destroy]

  def index
    @notifications = current_user.notifications
                                 .includes(:actor, :notifiable)
                                 .recent
                                 .page(params[:page]).per(20)

    # Marquer toutes les notifications affichées comme lues
    current_user.notifications.unread.update_all(read: true)
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
end
