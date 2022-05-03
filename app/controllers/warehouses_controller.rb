class WarehousesController < ApplicationController
  def show
    @warehouse = Warehouse.find(params[:id])
  end
end
