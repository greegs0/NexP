class Message < ApplicationRecord
  include Sanitizable

  belongs_to :sender, class_name: 'User'
  belongs_to :project, optional: true
  belongs_to :recipient, class_name: 'User', optional: true

  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
  validate :must_have_project_or_recipient

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(sender: user) }
  scope :direct_messages, -> { where(project_id: nil) }
  scope :project_messages, -> { where.not(project_id: nil) }
  scope :conversation_between, ->(user1, user2) {
    direct_messages.where(
      "(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)",
      user1.id, user2.id, user2.id, user1.id
    ).order(created_at: :asc)
  }

  def read?
    read_at.present?
  end

  def mark_as_read!
    update(read_at: Time.current) if read_at.blank?
  end

  def direct_message?
    project_id.nil?
  end

  private

  def must_have_project_or_recipient
    if project_id.blank? && recipient_id.blank?
      errors.add(:base, "Le message doit avoir soit un projet, soit un destinataire")
    end

    if project_id.present? && recipient_id.present?
      errors.add(:base, "Le message ne peut pas avoir à la fois un projet et un destinataire")
    end
  end
end
