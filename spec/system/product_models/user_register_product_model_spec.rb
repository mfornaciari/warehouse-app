require 'rails_helper'

describe 'Usuário cadastra um modelo de produto' do
  it 'a partir da tela inicial' do
    # Arrange
    fields = %w[Nome Código Fornecedor Peso Altura Largura Profundidade]

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'

    # Assert
    fields.each { |field| expect(page).to have_field field }
  end

  it 'com sucesso' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    fields_and_content = { 'Nome': 'Notebook', 'Código': 'NOTE-MARCA-123456789', 'Peso': '2000',
                           'Altura': '15', 'Largura': '25', 'Profundidade': '10' }

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    select 'ACME', from: 'Fornecedor'
    click_on 'Criar Modelo de produto'

    # Assert
    expect(current_path).to eq product_models_path
    expect(page).to have_content 'Modelo cadastrado com sucesso.'
    expect(page).to have_content 'Notebook'
  end

  it 'com dados incompletos' do
    # Arrange
    blank_fields = %w[Código Peso Altura Largura Profundidade]

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    fill_in 'Nome', with: 'Notebook'
    click_on 'Criar Modelo de produto'

    # Assert
    blank_fields.each { |field| expect(page).to have_content "#{field} não pode ficar em branco." }
    expect(page).to have_field 'Nome', with: 'Notebook'
  end

  it 'com código repetido' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    repeated_code_model = { 'Nome': 'Tablet', 'Código': 'NOTE-MARCA-123456789', 'Peso': '1000',
                            'Altura': '10', 'Largura': '8', 'Profundidade': '1' }

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    repeated_code_model.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Modelo de produto'

    # Assert
    expect(page).to have_content 'Código já está em uso.'
  end

  it 'com código inválido' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    invalid_code_model = { 'Nome': 'Tablet', 'Código': 'TABLET', 'Peso': '1000',
                           'Altura': '10', 'Largura': '8', 'Profundidade': '1' }

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    invalid_code_model.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Modelo de produto'

    # Assert
    expect(page).to have_content 'Código não é válido.'
  end

  it 'com peso inválido' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    invalid_weight_model = { 'Nome': 'Tablet', 'Código': 'TABLET-MARCA-1234567', 'Peso': '0',
                             'Altura': '10', 'Largura': '8', 'Profundidade': '1' }

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    invalid_weight_model.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Modelo de produto'

    # Assert
    expect(page).to have_content 'Peso deve ser maior que 0.'
  end

  it 'com altura inválida' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    invalid_height_model = { 'Nome': 'Tablet', 'Código': 'TABLET-MARCA-1234567', 'Peso': '500',
                             'Altura': '0', 'Largura': '8', 'Profundidade': '1' }

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    invalid_height_model.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Modelo de produto'

    # Assert
    expect(page).to have_content 'Altura deve ser maior que 0.'
  end

  it 'com largura inválida' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    invalid_width_model = { 'Nome': 'Tablet', 'Código': 'TABLET-MARCA-1234567', 'Peso': '500',
                            'Altura': '10', 'Largura': '0', 'Profundidade': '1' }

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    invalid_width_model.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Modelo de produto'

    # Assert
    expect(page).to have_content 'Largura deve ser maior que 0.'
  end

  it 'com profundidade inválida' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    invalid_depth_model = { 'Nome': 'Tablet', 'Código': 'TABLET-MARCA-1234567', 'Peso': '500',
                            'Altura': '10', 'Largura': '8', 'Profundidade': '0' }

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Cadastrar modelo'
    invalid_depth_model.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Modelo de produto'

    # Assert
    expect(page).to have_content 'Profundidade deve ser maior que 0.'
  end
end
