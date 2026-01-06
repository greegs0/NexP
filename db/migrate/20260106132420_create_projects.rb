class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description
      t.integer :max_members, default: 4
      t.integer :current_members_count, default: 0
      t.string :status, default: 'draft'
      t.string :visibility, default: 'public'
      t.date :start_date
      t.date :end_date
      t.date :deadline
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
