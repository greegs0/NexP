class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  validates :action, presence: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  # Actions possibles
  ACTIONS = {
    like: 'a aimé votre post',
    comment: 'a commenté votre post',
    follow: 'a commencé à vous suivre',
    project_join: 'a rejoint votre projet',
    mention: 'vous a mentionné',
    badge_earned: 'Badge débloqué!',
    message: 'vous a envoyé un message'
  }.freeze

  def message
    ACTIONS[action.to_sym] || action
  end

  def mark_as_read!
    update(read: true) unless read?
  end
end
