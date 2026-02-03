# frozen_string_literal: true

class CommentSerializer < BaseSerializer
  def as_json(options = {})
    result = {
      id: object.id,
      content: object.content,
      user: UserSerializer.new(object.user).as_json,
      created_at: object.created_at
    }

    # Image attachée
    if object.image.attached?
      result[:image_url] = Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true)
    end

    # Réponses (si demandé)
    if options[:include_replies] && object.respond_to?(:replies)
      result[:replies] = CommentSerializer.collection(object.replies)
    end

    result
  end
end
