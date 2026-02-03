# frozen_string_literal: true

class ProjectSerializer < BaseSerializer
  def as_json(options = {})
    detail = options[:detail] || false

    result = summary_json

    if detail
      result.merge!(detail_json)
    end

    result
  end

  private

  def summary_json
    {
      id: object.id,
      title: object.title,
      description: object.description,
      status: object.status,
      visibility: object.visibility,
      current_members_count: object.current_members_count,
      max_members: object.max_members,
      accepting_members: object.respond_to?(:accepting_members?) ? object.accepting_members? : true,
      owner: UserSerializer.new(object.owner).as_json,
      skills: SkillSerializer.collection(object.skills),
      created_at: object.created_at,
      updated_at: object.updated_at
    }
  end

  def detail_json
    {
      start_date: object.start_date,
      end_date: object.end_date,
      deadline: object.deadline,
      messages_count: object.messages_count,
      bookmarks_count: object.bookmarks_count,
      members: UserSerializer.collection(object.members)
    }
  end
end
