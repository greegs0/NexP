class AddParentIdToComments < ActiveRecord::Migration[7.1]
  def change
    add_reference :comments, :parent, foreign_key: { to_table: :comments }, index: true
  end
end
