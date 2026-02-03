# frozen_string_literal: true

class BadgeSerializer < BaseSerializer
  def as_json(options = {})
    {
      id: object.id,
      name: object.name,
      description: object.description
    }
  end
end
