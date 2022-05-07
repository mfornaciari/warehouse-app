class WarehousesController < ApplicationController
  def new
    @warehouse = Warehouse.new
  end

  def create
    warehouse_params = params.require(:warehouse).permit(:name, :description, :code, :city, :state, :cep, :area)
    Warehouse.create warehouse_params
    redirect_to root_path, notice: 'Galpão cadastrado com sucesso.'
  end

  def show
    @warehouse = Warehouse.find params[:id]
  end
end
