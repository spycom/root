class AddNatToService < ActiveRecord::Migration
  def change
    add_column :services, :nat, :integer
  end
end
