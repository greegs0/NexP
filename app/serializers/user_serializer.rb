# frozen_string_literal: true

class UserSerializer < BaseSerializer
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
      username: object.username,
      name: object.name,
      bio: object.bio,
      level: object.level,
      available: object.available,
      avatar_url: object.respond_to?(:avatar_url) ? object.avatar_url : nil,
      skills_count: object.skills.size,
      followers_count: object.followers_count,
      following_count: object.following_count
    }
  end

  def detail_json
    {
      email: object.email,
      zipcode: object.zipcode,
      portfolio_url: object.portfolio_url,
      github_url: object.github_url,
      linkedin_url: object.linkedin_url,
      experience_points: object.experience_points,
      posts_count: object.posts_count,
      owned_projects_count: object.owned_projects_count,
      bookmarks_count: object.bookmarks_count,
      skills: SkillSerializer.collection(object.skills),
      badges: BadgeSerializer.collection(object.badges),
      created_at: object.created_at,
      updated_at: object.updated_at
    }
  end
end
