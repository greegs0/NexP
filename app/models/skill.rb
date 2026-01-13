class Skill < ApplicationRecord
  CATEGORIES = [
    "Backend",
    "Frontend",
    "Database",
    "DevOps",
    "IA",
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
end
