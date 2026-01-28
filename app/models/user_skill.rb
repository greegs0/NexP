class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  enum proficiency_level: {
    beginner: 0,
    intermediate: 1,
    expert: 2
  }, _prefix: :proficiency

  validates :skill_id, uniqueness: {
    scope: :user_id,
    message: "déjà ajoutée à tes compétences"
  }

  default_scope { order(position: :asc) }

  def proficiency_label
    case proficiency_level
    when 'beginner' then 'Débutant'
    when 'intermediate' then 'Intermédiaire'
    when 'expert' then 'Expert'
    else 'Débutant'
    end
  end

  def proficiency_color
    case proficiency_level
    when 'beginner' then '#94a3b8'
    when 'intermediate' then '#3b82f6'
    when 'expert' then '#10b981'
    else '#94a3b8'
    end
  end
end
