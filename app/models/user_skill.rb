class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :skill_id, uniqueness: {
    scope: :user_id,
    message: "déjà ajoutée à tes compétences"
  }
end
