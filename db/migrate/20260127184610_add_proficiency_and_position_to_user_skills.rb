class AddProficiencyAndPositionToUserSkills < ActiveRecord::Migration[7.1]
  def change
    add_column :user_skills, :proficiency_level, :integer, default: 0, null: false
    add_column :user_skills, :position, :integer, default: 0, null: false
    add_index :user_skills, [:user_id, :position]
  end
end
