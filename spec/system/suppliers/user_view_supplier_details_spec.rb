require 'rails_helper'

describe 'Usuário visita tela de detalhes de um fornecedor' do
  it 'e vê informações adicionais' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: 'Avenida A, 10', city: 'Natal', state: 'RN', cep: '12345-678',
                     email: 'contato@acme.com', phone: '91234-5678')
    details_content = ['Nome fantasia: ACME', 'Razão social: ACME Ltda.', 'CNPJ: 1234567890123',
                       'Endereço: Avenida A, 10 - Natal/RN. CEP: 12345-678', 'E-mail: contato@acme.com',
                       'Telefone: 91234-5678']

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'

    # Assert
    details_content.each { |content| expect(page).to have_content content }
  end

  it 'e não vê detalhes não informados' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'

    # Assert
    expect(page).not_to have_content 'Endereço'
    expect(page).not_to have_content 'CEP'
    expect(page).not_to have_content 'Telefone'
  end

  it 'e volta para a tela inicial' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: 'Avenida A, 10', city: 'Natal', state: 'RN', cep: '12345-678',
                     email: 'contato@acme.com', phone: '91234-5678')

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq root_path
  end
end
