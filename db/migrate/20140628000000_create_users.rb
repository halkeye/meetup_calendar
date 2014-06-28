
class CreateUsers < ActiveRecord::Migration
  def change
     create_table :users do |t|
       t.string :guid, :null => false
       t.integer :uid, :null => false
       t.string :token, :null => false
       t.string :refresh_token, :null => false
       t.timestamp :expires_at, :null => false
       t.boolean :expires, :null => false

     end

     add_index :users, :guid, :unique => true
     add_index :users, :uid, :unique => true
  end

end
