namespace :cleanup do
  desc "Remove duplicate user_badges, keeping only the oldest one for each user-badge pair"
  task duplicate_badges: :environment do
    puts "Finding duplicate user_badges..."

    # Find all user_id/badge_id pairs that have duplicates
    duplicates = UserBadge.group(:user_id, :badge_id)
                          .having("COUNT(*) > 1")
                          .pluck(:user_id, :badge_id)

    puts "Found #{duplicates.count} user-badge pairs with duplicates"

    total_deleted = 0

    duplicates.each do |user_id, badge_id|
      # Keep the oldest one (first created), delete the rest
      records = UserBadge.where(user_id: user_id, badge_id: badge_id)
                         .order(created_at: :asc)

      to_keep = records.first
      to_delete = records.where.not(id: to_keep.id)

      count = to_delete.count
      to_delete.delete_all
      total_deleted += count
    end

    puts "Deleted #{total_deleted} duplicate user_badges"
  end
end
