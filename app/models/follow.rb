class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User', counter_cache: :following_count
  belongs_to :following, class_name: 'User', counter_cache: :followers_count

  validates :follower_id, uniqueness: { scope: :following_id }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    if follower_id == following_id
      errors.add(:base, "Vous ne pouvez pas vous suivre vous-même")
    end
  end
end
