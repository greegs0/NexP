class ProjectSkill < ApplicationRecord
  belongs_to :project
  belongs_to :skill

  validates :project_id, presence: true, uniqueness: { scope: :skill_id }
  validates :skill_id, presence: true
end
