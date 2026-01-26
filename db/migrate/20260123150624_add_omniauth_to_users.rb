class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :github_username, :string
    add_column :users, :gitlab_username, :string
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_refresh_token, :string
    add_column :users, :oauth_expires_at, :datetime

    # Index pour les recherches OAuth
    add_index :users, [:provider, :uid], unique: true
    add_index :users, :github_username
    add_index :users, :gitlab_username
  end
end
