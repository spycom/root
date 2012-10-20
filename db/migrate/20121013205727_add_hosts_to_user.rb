class AddHostsToUser < ActiveRecord::Migration
  def change
    add_column :users, :hosts, :integer
  end
end
