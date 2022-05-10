require 'rails_helper'

describe 'Usuário cadastra um fornecedor' do
  it 'a partir da tela inicial' do
    # Arrange
    fields = ['Nome fantasia', 'Razão social', 'CNPJ', 'Endereço',
              'Cidade', 'Estado', 'CEP', 'E-mail', 'Telefone']

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar fornecedor'

    # Assert
    fields.each { |field| expect(page).to have_field field }
  end

  it 'com sucesso' do
    # Arrange
    fields_and_content = { 'Nome fantasia': 'ACME', 'Razão social': 'ACME Ltda.', 'CNPJ': '1234567890123',
                           'Endereço': '', 'Cidade': '', 'Estado': '', 'CEP': '', 'E-mail': 'contato@acme.com',
                           'Telefone': '' }

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar fornecedor'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Fornecedor'

    # Assert
    expect(current_path).to eq suppliers_path
    expect(page).to have_content 'Fornecedor cadastrado com sucesso.'
    expect(page).to have_content 'ACME'
  end

  it 'com dados incompletos' do
    # Arrange
    blank_fields = ['Nome fantasia', 'Razão social', 'CNPJ', 'E-mail']
    filled_fields = { 'Endereço': 'Avenida A, 10', 'Cidade': 'Natal', 'Estado': 'RN', 'CEP': '12345-678',
                      'Telefone': '91234-5678' }

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar fornecedor'
    filled_fields.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Fornecedor'

    # Assert
    blank_fields.each { |field| expect(page).to have_content "#{field} não pode ficar em branco." }
    filled_fields.each_pair { |field, content| expect(page). to have_field field, with: content }
  end

  it 'com CNPJ repetido' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')
    repeated_number_supplier = { 'Nome fantasia': 'Stark', 'Razão social': 'Stark Industries Brasil Ltda.',
                                 'CNPJ': '1234567890123', 'E-mail': 'contato@stark.com.br' }

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar fornecedor'
    repeated_number_supplier.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Fornecedor'

    # Assert
    expect(page).to have_content 'CNPJ já está em uso.'
  end

  it 'com CNPJ inválido' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')
    invalid_number_supplier = { 'Nome fantasia': 'Campus', 'Razão social': 'Campus S/A',
                                'CNPJ': '123', 'E-mail': 'contato@campus.com' }

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar fornecedor'
    invalid_number_supplier.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Fornecedor'

    # Assert
    expect(page).to have_content 'CNPJ não é válido.'
  end
end
