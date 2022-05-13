require 'rails_helper'

describe 'Usuário edita um modelo de produto' do
  it 'a partir da página de detalhes' do
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    fields_and_content = { 'Nome': 'Notebook', 'Código': 'NOTE-MARCA-123456789', 'Peso': '2000',
                           'Altura': '15', 'Largura': '25', 'Profundidade': '10' }

    visit root_path
    find('nav').click_on 'Modelos de produto'
    find('section#product_models').click_on 'Notebook'
    click_on 'Editar'

    expect(page).to have_content 'Editar modelo'
    fields_and_content.each_pair { |field, content| expect(page).to have_field field, with: content }
    expect(page).to have_select 'Fornecedor', selected: 'ACME'
  end

  it 'com sucesso' do
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    Supplier.create!(brand_name: 'ACME2', corporate_name: 'ACME2 Ltda.', registration_number: 1_234_567_890_120,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme2.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    fields_and_content = { 'Nome': 'Tablet', 'Código': 'TABLET-MARCA-1234567', 'Peso': '1000',
                           'Altura': '10', 'Largura': '8', 'Profundidade': '1' }
    details_content = ['Modelo atualizado com sucesso.', 'Tablet', 'Código: TABLET-MARCA-1234567',
                       'Fornecedor: ACME', 'Peso: 1000',
                       'Dimensões: 10 cm de altura X 8 cm de largura X 1 cm de profundidade']

    visit root_path
    find('nav').click_on 'Modelos de produto'
    find('section#product_models').click_on 'Notebook'
    click_on 'Editar'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    select 'ACME2', from: 'Fornecedor'
    click_on 'Atualizar Modelo de produto'

    expect(current_path).to eq product_model_path(1)
    details_content.each { |content| expect(page).to have_content content }
  end

  it 'com dados incompletos' do
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    blank_fields = %w[Código Peso Altura Largura Profundidade]

    visit root_path
    find('nav').click_on 'Modelos de produto'
    find('section#product_models').click_on 'Notebook'
    click_on 'Editar'
    fill_in 'Nome', with: 'Tablet'
    blank_fields.each { |field| fill_in field, with: '' }
    click_on 'Atualizar Modelo de produto'

    blank_fields.each { |field| expect(page).to have_content "#{field} não pode ficar em branco." }
    expect(page).to have_field 'Nome', with: 'Tablet'
    expect(page).to have_select 'Fornecedor', selected: 'ACME'
  end

  it 'com código repetido' do
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    ProductModel.create!(name: 'Tablet', weight: 1_000, height: 10, width: 8, depth: 1,
                         code: 'TABLET-MARCA-1234567', supplier: acme)

    visit root_path
    find('nav').click_on 'Modelos de produto'
    find('section#product_models').click_on 'Notebook'
    click_on 'Editar'
    fill_in 'Código', with: 'TABLET-MARCA-1234567'
    click_on 'Atualizar Modelo de produto'

    expect(page).to have_content 'Código já está em uso.'
  end

  it 'com código inválido' do
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)

    visit root_path
    find('nav').click_on 'Modelos de produto'
    find('section#product_models').click_on 'Notebook'
    click_on 'Editar'
    fill_in 'Código', with: 'TABLET'
    click_on 'Atualizar Modelo de produto'

    expect(page).to have_content 'Código não é válido.'
  end

  it 'com valores <= 0' do
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    invalid_values = %w[Peso Altura Largura Profundidade]

    visit root_path
    find('nav').click_on 'Modelos de produto'
    find('section#product_models').click_on 'Notebook'
    click_on 'Editar'
    invalid_values.each { |field| fill_in field, with: '0' }
    click_on 'Atualizar Modelo de produto'

    invalid_values.each { |field| expect(page).to have_content "#{field} deve ser maior que 0." }
  end
end
