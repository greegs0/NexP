class AddCategoryToSkills < ActiveRecord::Migration[7.0]
  def change
    add_column :skills, :category, :string
    add_index :skills, :category
  end
end
