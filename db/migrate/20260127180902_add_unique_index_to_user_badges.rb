class AddUniqueIndexToUserBadges < ActiveRecord::Migration[7.1]
  def change
    # First, remove duplicates (keep oldest)
    reversible do |dir|
      dir.up do
        execute <<-SQL
          DELETE FROM user_badges
          WHERE id NOT IN (
            SELECT MIN(id)
            FROM user_badges
            GROUP BY user_id, badge_id
          )
        SQL
      end
    end

    # Then add unique index
    add_index :user_badges, [:user_id, :badge_id], unique: true, name: 'index_user_badges_uniqueness'
  end
end
