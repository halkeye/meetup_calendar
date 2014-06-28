class ChangeUidType < ActiveRecord::Migration
  def up
    change_column :users, :uid, :integer, :null => false
  end

  def down
    change_column :users, :uid, :string, :null => false
  end
end
