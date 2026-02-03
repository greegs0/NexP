# frozen_string_literal: true

# Classe de base pour les serializers
#
# Usage:
#   class UserSerializer < BaseSerializer
#     def as_json(options = {})
#       { id: object.id, name: object.name }
#     end
#   end
#
class BaseSerializer
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def as_json(options = {})
    raise NotImplementedError, "#{self.class} must implement #as_json"
  end

  def to_json(*args)
    as_json.to_json(*args)
  end

  # Sérialise une collection d'objets
  #
  # @param collection [Array] Collection d'objets à sérialiser
  # @param options [Hash] Options passées à as_json
  # @return [Array] Collection sérialisée
  def self.collection(collection, options = {})
    collection.map { |obj| new(obj).as_json(options) }
  end
end
