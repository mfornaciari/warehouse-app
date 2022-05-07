class Warehouse < ApplicationRecord
  validates :name, :description, :code, :city, :state, :cep, :area, presence: true
  validates :name, :code, uniqueness: true
  validates :cep, format: { with: /\A\d{5}-\d{3}\z/ }
end
