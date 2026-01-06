class CreateProjectSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :project_skills do |t|
      t.references :project, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end

    add_index :project_skills, [:project_id, :skill_id], unique: true
  end
end
