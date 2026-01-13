class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :project

  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(sender: user) }

  def read?
    read_at.present?
  end

  def mark_as_read!
    update_column(:read_at, Time.current) unless read?
  end
end
