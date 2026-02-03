class EncryptOAuthTokens < ActiveRecord::Migration[7.1]
  def change
    # Renommer les colonnes pour utiliser attr_encrypted
    # attr_encrypted ajoute automatiquement le préfixe 'encrypted_'
    rename_column :users, :oauth_token, :encrypted_oauth_token
    rename_column :users, :oauth_refresh_token, :encrypted_oauth_refresh_token

    # Ajouter les colonnes IV (Initialization Vector) pour AES
    add_column :users, :encrypted_oauth_token_iv, :string
    add_column :users, :encrypted_oauth_refresh_token_iv, :string
  end
end
