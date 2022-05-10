require 'rails_helper'

describe 'Usuário visita tela de fornecedores' do
  it 'a partir do menu de navegação' do
    # Arrange

    # Act
    visit root_path
    within 'nav' do
      click_on 'Fornecedores'
    end

    # Assert
    expect(current_path).to eq suppliers_path
    within 'section#suppliers' do
      expect(page).to have_content 'Fornecedores'
    end
  end

  it 'e volta para tela inicial' do
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq root_path
  end

  it 'e vê fornecedores cadastrados' do
    # Arrange
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: 'Avenida A, n. 10', city: 'Natal', state: 'RN', cep: '12345-678',
                     email: 'contato@acme.com', phone: '91234-5678')
    Supplier.create!(brand_name: 'Stark', corporate_name: 'Stark Industries Brasil Ltda.',
                     registration_number: 1_234_567_890_321, address: '', city: '', state: '', cep: '',
                     email: 'contato@stark.com.br', phone: '')

    # Act
    visit root_path
    click_on 'Fornecedores'

    # Assert
    expect(page).to have_content 'ACME'
    expect(page).to have_content 'Stark'
  end

  it 'e não existem fornecedores cadastrados' do
    # Arrange
    
    # Act
    visit root_path
    click_on 'Fornecedores'

    # Assert
    expect(page).to have_content 'Não existem fornecedores cadastrados.'
  end
end
