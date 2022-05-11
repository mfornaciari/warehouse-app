class ProductModel < ApplicationRecord
  belongs_to :supplier
  validates :name, :weight, :height, :width, :depth, :code, presence: true
  validates :code, uniqueness: true
  validates :code, format: { with: /\A\S{20}\z/ }
  validates :weight, :height, :width, :depth, comparison: { greater_than: 0 }
end
