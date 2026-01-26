class Bookmark < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :bookmarkable, polymorphic: true, counter_cache: true

  validates :user_id, uniqueness: { scope: [:bookmarkable_type, :bookmarkable_id] }
end
