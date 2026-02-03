# frozen_string_literal: true

class SkillSerializer < BaseSerializer
  def as_json(options = {})
    {
      id: object.id,
      name: object.name,
      category: object.category
    }
  end
end
