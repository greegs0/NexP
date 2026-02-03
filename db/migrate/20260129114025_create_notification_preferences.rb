class CreateNotificationPreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :notification_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification_type, null: false
      t.boolean :enabled, default: true, null: false
      t.boolean :email_enabled, default: false, null: false

      t.timestamps
    end

    add_index :notification_preferences, [:user_id, :notification_type], unique: true, name: 'index_notif_prefs_on_user_and_type'
  end
end
