class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers do |t|
      t.string :brand_name
      t.string :corporate_name
      t.integer :registration_number
      t.string :address
      t.string :city
      t.string :state
      t.string :cep
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
