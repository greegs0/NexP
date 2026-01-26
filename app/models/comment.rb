class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy
  has_one_attached :image

  validates :content, presence: true, length: { minimum: 1, maximum: 2000 }

  scope :top_level, -> { where(parent_id: nil) }

  # Note: Les validations d'image sont gérées côté client avec accept='image/*'
  # Pour ajouter des validations serveur, installer active_storage_validations et redémarrer le serveur

  # Sanitize le contenu avant sauvegarde pour prévenir XSS
  before_save :sanitize_content

  private

  def sanitize_content
    return if content.blank?

    # Supprime toutes les balises HTML pour prévenir XSS
    self.content = Rails::HTML5::FullSanitizer.new.sanitize(content)
  end
end
