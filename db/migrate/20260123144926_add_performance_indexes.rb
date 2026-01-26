class AddPerformanceIndexes < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    # Index pour le tri des posts par date (utilisé partout)
    add_index :posts, :created_at, algorithm: :concurrently, if_not_exists: true

    # Index composite pour le feed (posts des utilisateurs suivis)
    add_index :posts, [:user_id, :created_at], algorithm: :concurrently, if_not_exists: true

    # Index pour le filtrage des projets
    add_index :projects, :status, algorithm: :concurrently, if_not_exists: true
    add_index :projects, :visibility, algorithm: :concurrently, if_not_exists: true
    add_index :projects, :created_at, algorithm: :concurrently, if_not_exists: true
    add_index :projects, [:owner_id, :created_at], algorithm: :concurrently, if_not_exists: true
    add_index :projects, [:visibility, :status, :created_at], name: 'index_projects_on_visibility_status_created', algorithm: :concurrently, if_not_exists: true

    # Index pour le filtrage des utilisateurs
    add_index :users, :available, algorithm: :concurrently, if_not_exists: true
    add_index :users, :level, algorithm: :concurrently, if_not_exists: true
    add_index :users, :created_at, algorithm: :concurrently, if_not_exists: true

    # Index pour les badges
    add_index :badges, :name, algorithm: :concurrently, if_not_exists: true
    add_index :badges, :xp_required, algorithm: :concurrently, if_not_exists: true

    # Index composite pour éviter les doublons de badges
    add_index :user_badges, [:user_id, :badge_id], unique: true, algorithm: :concurrently, if_not_exists: true

    # Index pour les messages non lus
    add_index :messages, [:recipient_id, :read_at], algorithm: :concurrently, if_not_exists: true
    add_index :messages, [:project_id, :created_at], algorithm: :concurrently, if_not_exists: true

    # Index pour améliorer les requêtes de teams
    add_index :teams, [:project_id, :status], algorithm: :concurrently, if_not_exists: true
  end
end
