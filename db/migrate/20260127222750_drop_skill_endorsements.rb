class DropSkillEndorsements < ActiveRecord::Migration[7.1]
  def up
    drop_table :skill_endorsements, if_exists: true
  end

  def down
    create_table :skill_endorsements do |t|
      t.references :endorser, null: false, foreign_key: { to_table: :users }
      t.references :user_skill, null: false, foreign_key: true
      t.timestamps
    end
    add_index :skill_endorsements, [:endorser_id, :user_skill_id], unique: true
  end
end
