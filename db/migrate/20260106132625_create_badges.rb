class CreateBadges < ActiveRecord::Migration[7.1]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.text :description
      t.string :icon_url
      t.integer :xp_required

      t.timestamps
    end
  end
end
