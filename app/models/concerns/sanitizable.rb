# frozen_string_literal: true

# Concern pour la sanitization du contenu HTML
# Protège contre les attaques XSS en supprimant les balises HTML
#
# Usage:
#   class Post < ApplicationRecord
#     include Sanitizable
#   end
#
# Nécessite un attribut `content` sur le model
module Sanitizable
  extend ActiveSupport::Concern

  included do
    before_save :sanitize_content
  end

  private

  def sanitize_content
    return if content.blank?

    # Supprime toutes les balises HTML pour prévenir XSS
    self.content = Rails::HTML5::FullSanitizer.new.sanitize(content)
  end
end
