class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :project

  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }

  # Sanitize le contenu avant sauvegarde pour prévenir XSS
  before_save :sanitize_content

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(sender: user) }

  def read?
    read_at.present?
  end

  def mark_as_read!
    update(read_at: Time.current) if read_at.blank?
  end

  private

  def sanitize_content
    return if content.blank?

    # Supprime toutes les balises HTML pour prévenir XSS
    self.content = Rails::HTML5::FullSanitizer.new.sanitize(content)
  end
end
