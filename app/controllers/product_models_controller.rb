class ProductModelsController < ApplicationController
  before_action :set_product_model, only: %i[show edit update]

  def index
    @product_models = ProductModel.all
  end

  def show; end

  def new
    @product_model = ProductModel.new
  end

  def create
    @product_model = ProductModel.new product_model_params
    if @product_model.save
      redirect_to product_models_path, notice: 'Modelo cadastrado com sucesso.'
    else
      flash.now[:notice] = 'Modelo não cadastrado.'
      render 'new'
    end
  end

  def edit; end

  def update
    if @product_model.update(product_model_params)
      redirect_to @product_model, notice: 'Modelo atualizado com sucesso.'
    else
      flash.now[:notice] = 'Modelo não atualizado.'
      render 'edit'
    end
  end

  private

  def set_product_model
    @product_model = ProductModel.find params[:id]
  end

  def product_model_params
    params.require(:product_model).permit(:name, :code, :supplier_id, :weight, :height, :width, :depth)
  end
end
