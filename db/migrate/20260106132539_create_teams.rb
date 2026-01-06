class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :role
      t.string :status, default: 'pending'
      t.datetime :joined_at

      t.timestamps
    end

    add_index :teams, [:user_id, :project_id], unique: true
  end
end
