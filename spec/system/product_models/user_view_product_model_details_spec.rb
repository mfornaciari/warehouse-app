require 'rails_helper'

describe 'Usuário visita tela de detalhes de um modelo de produto' do
  it 'e vê informações adicionais' do
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    details_content = ['Notebook', 'Código: NOTE-MARCA-123456789', 'Fornecedor: ACME',
                       'Peso: 2000 g', 'Dimensões: 15 cm de altura X 25 cm de largura X 10 cm de profundidade']

    visit root_path
    find('nav').click_on 'Modelos de produto'
    find('section#product_models').click_on 'Notebook'

    details_content.each { |content| expect(page).to have_content content }
  end

  it 'e volta para a tela inicial' do
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)

    visit root_path
    find('nav').click_on 'Modelos de produto'
    find('section#product_models').click_on 'Notebook'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
