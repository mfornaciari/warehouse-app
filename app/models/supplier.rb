class Supplier < ApplicationRecord
  validates :brand_name, :corporate_name, :registration_number, :email, presence: true
  validates :registration_number, uniqueness: true
  validates :registration_number, format: { with: /\A\d{13}\z/ }
  validates :cep, format: { with: /\A\d{5}-\d{3}\z/ }, allow_blank: true
end
