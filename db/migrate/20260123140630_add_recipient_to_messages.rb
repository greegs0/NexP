class AddRecipientToMessages < ActiveRecord::Migration[7.1]
  def change
    # Rendre project_id nullable pour permettre les messages directs
    change_column_null :messages, :project_id, true

    # Ajouter recipient_id (nullable car peut être un message de projet)
    add_reference :messages, :recipient, null: true, foreign_key: { to_table: :users }

    # Ajouter des index
    add_index :messages, [:sender_id, :recipient_id, :created_at]
  end
end
