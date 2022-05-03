class RemoveAddressFromWarehouses < ActiveRecord::Migration[7.0]
  def change
    remove_column :warehouses, :address, :string
  end
end
