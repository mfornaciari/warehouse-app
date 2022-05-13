require 'rails_helper'

describe 'Usuário cadastra um modelo de produto' do
  it 'a partir da tela inicial' do
    fields = %w[Nome Código Fornecedor Peso Altura Largura Profundidade]

    visit root_path
    find('nav').click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'

    fields.each { |field| expect(page).to have_field field }
  end

  it 'com sucesso' do
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')
    fields_and_content = { 'Nome': 'Notebook', 'Código': 'NOTE-MARCA-123456789', 'Peso': '2000',
                           'Altura': '15', 'Largura': '25', 'Profundidade': '10' }

    visit root_path
    find('nav').click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    select 'ACME', from: 'Fornecedor'
    click_on 'Criar Modelo de produto'

    expect(current_path).to eq product_models_path
    expect(page).to have_content 'Modelo cadastrado com sucesso.'
    expect(page).to have_content 'Notebook'
  end

  it 'com dados incompletos' do
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')
    blank_fields = %w[Código Peso Altura Largura Profundidade]

    visit root_path
    find('nav').click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    fill_in 'Nome', with: 'Notebook'
    click_on 'Criar Modelo de produto'

    blank_fields.each { |field| expect(page).to have_content "#{field} não pode ficar em branco." }
    expect(page).to have_field 'Nome', with: 'Notebook'
  end

  it 'com código repetido' do
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)

    visit root_path
    find('nav').click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    fill_in 'Código', with: 'NOTE-MARCA-123456789'
    click_on 'Criar Modelo de produto'

    expect(page).to have_content 'Código já está em uso.'
  end

  it 'com código inválido' do
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                     registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                     email: 'contato@acme.com', phone: '')

    visit root_path
    find('nav').click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    fill_in 'Código', with: 'TABLET'
    click_on 'Criar Modelo de produto'

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
    click_on 'Cadastrar modelo'
    invalid_values.each { |field| fill_in field, with: '0' }
    click_on 'Criar Modelo de produto'

    invalid_values.each { |field| expect(page).to have_content "#{field} deve ser maior que 0." }
  end
end
