class Badge < ApplicationRecord
  include Cacheable

  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  validates :name, presence: true

  # Callbacks pour invalider le cache
  after_save :expire_cache
  after_destroy :expire_cache

  # Cache tous les badges (rarement modifiés)
  def self.all_cached
    Rails.cache.fetch('badges/all', expires_in: 12.hours) do
      order(:xp_required).to_a
    end
  end
end
