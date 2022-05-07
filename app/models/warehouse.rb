class Warehouse < ApplicationRecord
  validates :name, :description, :code, :city, :state, :cep, :area, presence: true
end
