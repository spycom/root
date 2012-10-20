class AddHardsToUser < ActiveRecord::Migration
  def change
    add_column :users, :memory, :integer
    add_column :users, :storage, :integer
    add_column :users, :power, :integer
    add_column :users, :network, :integer
  end
end
