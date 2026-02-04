class AddPlanToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :plan, :string, default: 'free', null: false
    add_column :users, :messages_count_this_month, :integer, default: 0, null: false
    add_column :users, :messages_reset_at, :datetime

    add_index :users, :plan
  end
end
