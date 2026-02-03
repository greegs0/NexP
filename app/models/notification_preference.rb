class NotificationPreference < ApplicationRecord
  belongs_to :user

  # Types de notifications disponibles
  NOTIFICATION_TYPES = %w[
    like
    comment
    comment_reply
    follow
    mention
    post_mention
    project_join
    project_invite
    project_update
    team_join
    skill_add
    skill_level_up
    badge_earned
    message
    bookmark_update
    weekly_summary
  ].freeze

  validates :notification_type, presence: true, inclusion: { in: NOTIFICATION_TYPES }
  validates :notification_type, uniqueness: { scope: :user_id }

  scope :enabled, -> { where(enabled: true) }
  scope :email_enabled, -> { where(email_enabled: true) }
  scope :for_type, ->(type) { where(notification_type: type) }

  # Vérifie si un type de notification est activé pour un utilisateur
  def self.enabled_for?(user, notification_type)
    pref = user.notification_preferences.find_by(notification_type: notification_type)
    pref.nil? ? true : pref.enabled # Par défaut activé si pas de préférence
  end

  # Vérifie si les emails sont activés pour un type
  def self.email_enabled_for?(user, notification_type)
    pref = user.notification_preferences.find_by(notification_type: notification_type)
    pref.nil? ? false : pref.email_enabled # Par défaut désactivé si pas de préférence
  end
end
