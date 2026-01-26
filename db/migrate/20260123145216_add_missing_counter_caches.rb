class AddMissingCounterCaches < ActiveRecord::Migration[7.1]
  def change
    # Counter caches pour les utilisateurs
    add_column :users, :posts_count, :integer, default: 0, null: false
    add_column :users, :followers_count, :integer, default: 0, null: false
    add_column :users, :following_count, :integer, default: 0, null: false
    add_column :users, :owned_projects_count, :integer, default: 0, null: false
    add_column :users, :bookmarks_count, :integer, default: 0, null: false

    # Counter cache pour les projets
    add_column :projects, :messages_count, :integer, default: 0, null: false
    add_column :projects, :bookmarks_count, :integer, default: 0, null: false

    # Réinitialiser les compteurs avec les valeurs correctes
    reversible do |dir|
      dir.up do
        # Posts count
        execute <<-SQL.squish
          UPDATE users
          SET posts_count = (SELECT COUNT(*) FROM posts WHERE posts.user_id = users.id)
        SQL

        # Followers count
        execute <<-SQL.squish
          UPDATE users
          SET followers_count = (SELECT COUNT(*) FROM follows WHERE follows.following_id = users.id)
        SQL

        # Following count
        execute <<-SQL.squish
          UPDATE users
          SET following_count = (SELECT COUNT(*) FROM follows WHERE follows.follower_id = users.id)
        SQL

        # Owned projects count
        execute <<-SQL.squish
          UPDATE users
          SET owned_projects_count = (SELECT COUNT(*) FROM projects WHERE projects.owner_id = users.id)
        SQL

        # User bookmarks count
        execute <<-SQL.squish
          UPDATE users
          SET bookmarks_count = (SELECT COUNT(*) FROM bookmarks WHERE bookmarks.user_id = users.id)
        SQL

        # Project messages count
        execute <<-SQL.squish
          UPDATE projects
          SET messages_count = (SELECT COUNT(*) FROM messages WHERE messages.project_id = projects.id)
        SQL

        # Project bookmarks count
        execute <<-SQL.squish
          UPDATE projects
          SET bookmarks_count = (
            SELECT COUNT(*)
            FROM bookmarks
            WHERE bookmarks.bookmarkable_type = 'Project'
            AND bookmarks.bookmarkable_id = projects.id
          )
        SQL
      end
    end
  end
end
