require 'rails_helper'

describe 'Usuário visita tela de fornecedores' do
  it 'a partir da tela inicial' do
    # Arrange

    # Act
    visit root_path
    within 'nav' do
      click_on 'Fornecedores'
    end

    # Assert
    expect(current_path).to eq suppliers_path
    within('section#suppliers') do
      expect(page).to have_content 'Fornecedores'
    end
  end

  it 'e volta para tela inicial' do
    # Arrange

    # Act
    visit root_path
    within 'nav' do
      click_on 'Fornecedores'
    end
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq root_path
  end
end
