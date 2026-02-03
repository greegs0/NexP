class NotificationCleanupJob < ApplicationJob
  queue_as :cleanup

  # Nettoie les anciennes notifications
  # Peut être lancé quotidiennement ou hebdomadairement via un cron job
  def perform(days_read: 30, days_unread: 90)
    Rails.logger.info "Starting notification cleanup..."

    read_count = Notification.cleanup_old(days_read: days_read, days_unread: days_unread)

    Rails.logger.info "Notification cleanup completed. Deleted notifications: #{read_count}"
  end
end
