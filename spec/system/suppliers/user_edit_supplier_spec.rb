require 'rails_helper'

describe 'Usuário edita um galpão' do
  it 'a partir da página de detalhes' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')
    fields_and_content = { 'Nome fantasia': 'ACME', 'Razão social': 'ACME Ltda.', 'CNPJ': '1234567890123',
                           'Endereço': '', 'Cidade': '', 'Estado': '', 'CEP': '', 'E-mail': 'contato@acme.com',
                           'Telefone': '' }

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Editar'

    # Assert
    expect(page).to have_content 'Editar fornecedor'
    fields_and_content.each_pair { |field, content| expect(page).to have_field field, with: content }
  end

  it 'com sucesso' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')
    fields_and_content = { 'Nome fantasia': 'ACME2', 'Razão social': 'ACME2 Ltda.', 'CNPJ': '1234567890120',
                           'Endereço': 'Avenida A, 10', 'Cidade': 'Natal', 'Estado': 'RN', 'CEP': '12345-678',
                           'E-mail': 'contato@acme2.com', 'Telefone': '91234-5678' }
    details_content = ['Fornecedor atualizado com sucesso.', 'Nome fantasia: ACME2', 'Razão social: ACME2 Ltda.',
                       'Endereço: Avenida A, 10 - Natal/RN. CEP: 12345-678', 'E-mail: contato@acme2.com',
                       'Telefone: 91234-5678']

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Editar'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    click_on 'Atualizar Fornecedor'

    # Assert
    expect(current_path).to eq supplier_path(1)
    details_content.each { |content| expect(page).to have_content content }
  end

  it 'com dados incompletos' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')
    fields = ['Nome fantasia', 'Razão social', 'CNPJ', 'E-mail']

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Editar'
    fields.each { |field| fill_in field, with: '' }
    click_on 'Atualizar Fornecedor'

    # Assert
    expect(page).to have_content 'Fornecedor não atualizado.'
    fields.each { |field| expect(page).to have_content "#{field} não pode ficar em branco." }
    expect(page).not_to have_content 'CNPJ não é válido.'
  end

  it 'com CNPJ repetido' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')
    Supplier.create!(brand_name: 'Stark', corporate_name: 'Stark Industries Brasil Ltda.',
                     registration_number: 1_234_567_890_120, address: '', city: '', state: '', cep: '',
                     email: 'contato@stark.com.br', phone: '')

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Stark'
    click_on 'Editar'
    fill_in 'CNPJ', with: '1234567890123'
    click_on 'Atualizar Fornecedor'

    # Assert
    expect(page).to have_content 'CNPJ já está em uso.'
  end

  it 'com CNPJ inválido' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Editar'
    fill_in 'CNPJ', with: '123'
    click_on 'Atualizar Fornecedor'

    # Assert
    expect(page).to have_content 'CNPJ não é válido.'
  end
end
