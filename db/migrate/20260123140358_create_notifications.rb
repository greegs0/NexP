class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.references :notifiable, polymorphic: true, null: false
      t.string :action, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end

    add_index :notifications, [:user_id, :read, :created_at]
    add_index :notifications, [:notifiable_type, :notifiable_id]
  end
end
