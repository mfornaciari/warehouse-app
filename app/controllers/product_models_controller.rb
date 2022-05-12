class ProductModelsController < ApplicationController
  before_action :set_product_model, only: %i[show]

  def index
    @product_models = ProductModel.all
  end

  def show; end

  private

  def set_product_model
    @product_model = ProductModel.find params[:id]
  end
end
