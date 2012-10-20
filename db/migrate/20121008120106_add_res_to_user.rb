class AddResToUser < ActiveRecord::Migration
  def change
    add_column :users, :sociology, :integer
    add_column :users, :stealth, :integer
    add_column :users, :telepresence, :integer
  end
end
