class AddEnhancementsToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :url, :string
    add_column :notifications, :grouped_count, :integer, default: 1
    add_column :notifications, :metadata, :jsonb, default: {}

    add_index :notifications, :url
    add_index :notifications, :grouped_count
  end
end
