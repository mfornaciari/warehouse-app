require 'rails_helper'

describe 'Usuário edita um modelo de produto' do
  it 'a partir da página de detalhes' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    fields_and_content = { 'Nome': 'Notebook', 'Código': 'NOTE-MARCA-123456789', 'Peso': '2000',
                           'Altura': '15', 'Largura': '25', 'Profundidade': '10' }

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Notebook'
    click_on 'Editar'

    # Assert
    expect(page).to have_content 'Editar modelo'
    fields_and_content.each_pair { |field, content| expect(page).to have_field field, with: content }
    expect(page).to have_select 'Fornecedor', selected: 'ACME'
  end

  it 'com sucesso' do
    # Arrange
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

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Notebook'
    click_on 'Editar'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    select 'ACME2', from: 'Fornecedor'
    click_on 'Atualizar Modelo de produto'

    # Assert
    expect(current_path).to eq product_model_path(1)
    details_content.each { |content| expect(page).to have_content content }
  end

  it 'com dados incompletos' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    blank_fields = %w[Código Peso Altura Largura Profundidade]

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Notebook'
    click_on 'Editar'
    fill_in 'Nome', with: 'Tablet'
    blank_fields.each { |field| fill_in field, with: '' }
    click_on 'Atualizar Modelo de produto'

    # Assert
    blank_fields.each { |field| expect(page).to have_content "#{field} não pode ficar em branco." }
    expect(page).to have_field 'Nome', with: 'Tablet'
    expect(page).to have_select 'Fornecedor', selected: 'ACME'
  end

  it 'com código repetido' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    ProductModel.create!(name: 'Tablet', weight: 1_000, height: 10, width: 8, depth: 1,
                         code: 'TABLET-MARCA-1234567', supplier: acme)

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Notebook'
    click_on 'Editar'
    fill_in 'Código', with: 'TABLET-MARCA-1234567'
    click_on 'Atualizar Modelo de produto'

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

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Notebook'
    click_on 'Editar'
    fill_in 'Código', with: 'TABLET'
    click_on 'Atualizar Modelo de produto'

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

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Notebook'
    click_on 'Editar'
    fill_in 'Peso', with: '0'
    click_on 'Atualizar Modelo de produto'

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

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Notebook'
    click_on 'Editar'
    fill_in 'Altura', with: '0'
    click_on 'Atualizar Modelo de produto'

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

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Notebook'
    click_on 'Editar'
    fill_in 'Largura', with: '0'
    click_on 'Atualizar Modelo de produto'

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

    # Act
    visit root_path
    click_on 'Modelos de produto'
    click_on 'Notebook'
    click_on 'Editar'
    fill_in 'Profundidade', with: '0'
    click_on 'Atualizar Modelo de produto'

    # Assert
    expect(page).to have_content 'Profundidade deve ser maior que 0.'
  end
end
