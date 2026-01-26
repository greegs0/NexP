module Broadcastable
  extend ActiveSupport::Concern

  private

  def broadcast_notification(notification)
    NotificationChannel.broadcast_to(notification.user, {
      id: notification.id,
      actor_name: notification.actor.display_name,
      message: notification.message,
      created_at: notification.created_at,
      unread_count: notification.user.notifications.unread.count
    })
  end

  def broadcast_message(message, recipient_id)
    ActionCable.server.broadcast(
      "conversation_#{message.sender_id}_#{recipient_id}",
      {
        message: message.content,
        sender_name: message.sender.display_name,
        created_at: message.created_at
      }
    )
  end
end
