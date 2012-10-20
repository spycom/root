class CreateServiceStores < ActiveRecord::Migration
  def change
    create_table :service_stores do |t|
      t.integer :id
      t.string :name
      t.integer :price
      t.integer :exp

      t.timestamps
    end
  end
end
