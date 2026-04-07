# db/migrate/XXXXXX_create_revoked_tokens.rb
class CreateRevokedTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :revoked_tokens do |t|
      t.string  :jti,        null: false   # JWT ID (unique)
      t.integer :user_id,    null: false   # เจ้าของ token
      t.datetime :expires_at, null: false   # เวลาที่ควรลบออก
      t.timestamps
    end
    
    add_index :revoked_tokens, :jti, unique: true
    add_index :revoked_tokens, :expires_at
  end
end