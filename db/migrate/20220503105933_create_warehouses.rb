class CreateWarehouses < ActiveRecord::Migration[7.0]
  def change
    create_table :warehouses do |t|
      t.string :name
      t.string :code
      t.string :city
      t.integer :area

      t.timestamps
    end
  end
end
