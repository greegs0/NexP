class AddCategoryToBadges < ActiveRecord::Migration[7.1]
  def change
    add_column :badges, :category, :string
    add_index :badges, :category
  end
end
