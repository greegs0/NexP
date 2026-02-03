class AddConfirmableToDevise < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string # Only if using reconfirmable

    add_index :users, :confirmation_token, unique: true

    # Confirmer automatiquement tous les utilisateurs existants
    # Pour éviter de bloquer les utilisateurs actuels
    User.update_all(confirmed_at: Time.current)
  end

  def down
    remove_index :users, :confirmation_token
    remove_column :users, :unconfirmed_email
    remove_column :users, :confirmation_sent_at
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_token
  end
end
