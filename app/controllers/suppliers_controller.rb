class SuppliersController < ApplicationController
  def index
    @suppliers = Supplier.all
  end
end
