class WarehousesController < ApplicationController
  def new
    @warehouse = Warehouse.new
  end

  def create
    warehouse_params = params.require(:warehouse).permit(:name, :description, :code, :city, :state, :cep, :area)
    @warehouse = Warehouse.new warehouse_params
    if @warehouse.save
      redirect_to root_path, notice: 'Galpão cadastrado com sucesso.'
    else
      flash.now[:notice] = 'Galpão não cadastrado.'
      render 'new'
    end
  end

  def show
    @warehouse = Warehouse.find params[:id]
  end
end
