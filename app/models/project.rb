class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :teams, dependent: :destroy
  has_many :members, through: :teams, source: :user

  has_many :project_skills, dependent: :destroy
  has_many :skills, through: :project_skills

  has_many :messages, dependent: :destroy

  validates :title, presence: true
  validates :max_members, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[draft open in_progress completed archived] }
  validates :visibility, inclusion: { in: %w[public private] }
end
