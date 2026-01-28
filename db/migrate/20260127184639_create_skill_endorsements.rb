class CreateSkillEndorsements < ActiveRecord::Migration[7.1]
  def change
    create_table :skill_endorsements do |t|
      t.references :endorser, null: false, foreign_key: { to_table: :users }
      t.references :user_skill, null: false, foreign_key: true

      t.timestamps
    end

    add_index :skill_endorsements, [:endorser_id, :user_skill_id], unique: true, name: 'index_skill_endorsements_uniqueness'
  end
end
