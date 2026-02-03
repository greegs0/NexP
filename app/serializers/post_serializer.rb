# frozen_string_literal: true

class PostSerializer < BaseSerializer
  def as_json(options = {})
    current_user = options[:current_user]
    include_comments = options[:include_comments] || false

    result = {
      id: object.id,
      content: object.content,
      user: UserSerializer.new(object.user).as_json,
      likes_count: object.likes_count,
      comments_count: object.comments_count,
      created_at: object.created_at,
      updated_at: object.updated_at
    }

    # Image attachée
    if object.image.attached?
      result[:image_url] = Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true)
    end

    # Statut like pour l'utilisateur courant
    if current_user
      result[:liked_by_current_user] = object.likes.exists?(user_id: current_user.id)
    end

    # Commentaires récents
    if include_comments
      result[:recent_comments] = CommentSerializer.collection(
        object.comments.includes(:user).order(created_at: :desc).limit(3)
      )
    end

    result
  end
end
