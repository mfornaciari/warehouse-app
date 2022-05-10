require 'rails_helper'

describe 'Usuário visita tela de fornecedores' do
  it 'a partir da tela inicial' do
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'

    # Assert
    expect(current_path).to eq suppliers_path
    expect(page).to have_content 'Fornecedores', count: 2
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
end
