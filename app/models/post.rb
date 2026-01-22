class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  validates :content, presence: true, length: { minimum: 1, maximum: 5000 }

  # Sanitize le contenu avant sauvegarde pour prévenir XSS
  before_save :sanitize_content

  private

  def sanitize_content
    return if content.blank?

    # Supprime toutes les balises HTML pour prévenir XSS
    self.content = Rails::HTML5::FullSanitizer.new.sanitize(content)
  end
end
