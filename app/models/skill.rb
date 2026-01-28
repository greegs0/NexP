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
  scope :by_popularity, -> { order(users_count: :desc, popularity_score: :desc) }

  # Recherche intelligente via le service
  def self.smart_search(query, user: nil, limit: 20)
    service = SkillSuggestionService.new(user)
    service.search(query, limit: limit)
  end

  # Obtenir les suggestions pour un utilisateur
  def self.suggestions_for(user)
    service = SkillSuggestionService.new(user)
    service.get_all_suggestions
  end

  # Mettre a jour les scores de popularite (a executer periodiquement)
  def self.update_popularity_scores
    find_each do |skill|
      recent_users = skill.user_skills.where('created_at > ?', 30.days.ago).count
      total_users = skill.user_skills.count
      projects = skill.project_skills.count

      skill.update_columns(
        users_count: total_users,
        popularity_score: (recent_users * 3) + (total_users * 1) + (projects * 2)
      )
    end
    Rails.cache.delete('skills/all_ordered')
    Rails.cache.delete('skills/categories_grouped')
  end

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

  # Trouve les compétences souvent associées avec celles fournies
  # Utile pour les suggestions "Ajouter aussi"
  def self.commonly_paired_with(skill_ids, limit: 5)
    return none if skill_ids.blank?

    # Trouver les utilisateurs qui ont ces skills
    users_with_skills = UserSkill.where(skill_id: skill_ids).select(:user_id)

    # Trouver les autres skills de ces utilisateurs, ordonnés par fréquence
    joins(:user_skills)
      .where(user_skills: { user_id: users_with_skills })
      .where.not(id: skill_ids)
      .group(:id)
      .order(Arel.sql('COUNT(*) DESC'))
      .limit(limit)
  end

  # Compétences populaires globalement
  def self.trending(limit: 10)
    joins(:user_skills)
      .group(:id)
      .order(Arel.sql('COUNT(*) DESC'))
      .limit(limit)
  end

  def expire_cache
    super
    Rails.cache.delete('skills/all_ordered')
    Rails.cache.delete('skills/categories_grouped')
  end
end
