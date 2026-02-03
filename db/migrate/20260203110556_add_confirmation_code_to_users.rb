class AddConfirmationCodeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :confirmation_code, :string
    add_column :users, :confirmation_code_sent_at, :datetime
    add_index :users, :confirmation_code
  end
end
