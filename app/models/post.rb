class Post < ApplicationRecord
  include Sanitizable

  belongs_to :user, counter_cache: true
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy

  has_one_attached :image

  validates :content, presence: true, length: { minimum: 1, maximum: 5000 }
  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?

    unless image.blob.byte_size <= 5.megabytes
      errors.add(:image, "doit faire moins de 5 Mo")
    end

    acceptable_types = ["image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"]
    unless acceptable_types.include?(image.blob.content_type)
      errors.add(:image, "doit être un JPEG, PNG, GIF ou WebP")
    end
  end
end
