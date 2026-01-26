class Skill < ApplicationRecord
  include Cacheable

  CATEGORIES = [
    "Backend",
    "Frontend",
    "Mobile",
    "Database",
    "DevOps",
    "IA & Data",
    "Design",
    "Product & Business",
    "Security",
    "Testing & QA",
    "Blockchain",
    "Game Dev",
    "Tools",
    "Autre"
  ].freeze

  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills

  has_many :project_skills, dependent: :destroy
  has_many :projects, through: :project_skills

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  scope :by_category, ->(category) { where(category: category) }
  scope :search, ->(query) { where("name ILIKE ?", "%#{query}%") }

  # Callbacks pour invalider le cache
  after_save :expire_cache
  after_destroy :expire_cache

  # Méthodes de cache personnalisées
  def self.all_cached
    Rails.cache.fetch('skills/all_ordered', expires_in: 6.hours) do
      order(:category, :name).to_a
    end
  end

  def self.categories_with_skills
    Rails.cache.fetch('skills/categories_grouped', expires_in: 6.hours) do
      all_cached.group_by(&:category)
    end
  end

  def expire_cache
    super
    Rails.cache.delete('skills/all_ordered')
    Rails.cache.delete('skills/categories_grouped')
  end
end
