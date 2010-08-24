class AddFieldsInUsersForActivation < ActiveRecord::Migration
  def self.up
     add_column :users, :active, :boolean, :default => false, :null => false
     add_column :users, :perishable_token, :string,    :null => false 
     add_column :users, :email, :string, :null => false   
  end

  def self.down
    remove_column :users, :active
    remove_column :users, :email
    remove_column :users, :perishable_token
  end
end
