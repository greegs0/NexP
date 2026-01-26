class Project < ApplicationRecord
  # Constants
  STATUSES = %w[draft open in_progress completed archived].freeze
  VISIBILITIES = %w[public private].freeze

  # Associations
  belongs_to :owner, class_name: 'User', counter_cache: :owned_projects_count

  has_many :teams, dependent: :destroy
  has_many :members, through: :teams, source: :user

  has_many :project_skills, dependent: :destroy
  has_many :skills, through: :project_skills

  has_many :messages, dependent: :destroy, counter_cache: true

  has_many :bookmarks, as: :bookmarkable, dependent: :destroy, counter_cache: true

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 2000 }, allow_blank: true
  validates :max_members, numericality: { greater_than: 0, less_than_or_equal_to: 50 }
  validates :current_members_count, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :visibility, inclusion: { in: VISIBILITIES }
  validate :end_date_after_start_date
  validate :deadline_is_future

  # Scopes
  scope :public_projects, -> { where(visibility: 'public') }
  scope :private_projects, -> { where(visibility: 'private') }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :available, -> { where('current_members_count < max_members').where.not(status: ['completed', 'archived']) }
  scope :recent, -> { order(created_at: :desc) }
  scope :with_skill, ->(skill_id) { joins(:project_skills).where(project_skills: { skill_id: skill_id }) }

  # Methods
  def full?
    current_members_count >= max_members
  end

  def accepting_members?
    !full? && %w[open in_progress].include?(status) && visibility == 'public'
  end

  def member?(user)
    members.include?(user) || owner == user
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "doit être postérieure à la date de début")
    end
  end

  def deadline_is_future
    return if deadline.blank?

    if deadline < Date.today
      errors.add(:deadline, "doit être dans le futur")
    end
  end
end
