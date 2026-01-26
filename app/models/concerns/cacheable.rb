module Cacheable
  extend ActiveSupport::Concern

  class_methods do
    # Cache une requête avec expiration
    def cached_find(id, expires_in: 1.hour)
      Rails.cache.fetch("#{name.downcase}/#{id}", expires_in: expires_in) do
        find(id)
      end
    end

    # Cache une collection avec expiration
    def cached_all(expires_in: 1.hour)
      Rails.cache.fetch("#{name.downcase}/all", expires_in: expires_in) do
        all.to_a
      end
    end

    # Cache par catégorie (pour Skills)
    def cached_by_category(category, expires_in: 1.hour)
      Rails.cache.fetch("#{name.downcase}/category/#{category}", expires_in: expires_in) do
        where(category: category).to_a
      end
    end
  end

  # Invalide le cache de cet objet
  def expire_cache
    Rails.cache.delete("#{self.class.name.downcase}/#{id}")
    Rails.cache.delete("#{self.class.name.downcase}/all")
  end
end
