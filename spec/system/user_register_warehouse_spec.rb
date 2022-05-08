require 'rails_helper'

describe 'Usuário cadastra um galpão' do
  it 'a partir da tela inicial' do
    # Arrange
    fields = %w[Nome Descrição Código Cidade Estado CEP Área]

    # Act
    visit root_path
    click_on 'Cadastrar galpão'

    # Assert
    fields.each { |field| expect(page).to have_field field }
  end

  it 'com sucesso' do
    # Arrange
    fields_and_content = { 'Nome': 'Aeroporto SP', 'Descrição': 'Galpão destinado para cargas internacionais.',
                           'Código': 'GRU', 'Cidade': 'Guarulhos', 'Estado': 'SP', 'CEP': '15000-000',
                           'Área': '100000' }
    index_content = ['Galpão cadastrado com sucesso.', 'Aeroporto SP', 'Código: GRU', 'Cidade: Guarulhos',
                     'Área: 100000 m2']

    # Act
    visit root_path
    click_on 'Cadastrar galpão'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Galpão'

    # Assert
    expect(current_path).to eq root_path

    index_content.each { |content| expect(page).to have_content content }
  end

  it 'com dados incompletos' do
    # Arrange
    fields = %w[Nome Descrição Código Cidade Estado CEP Área]

    # Act
    visit root_path
    click_on 'Cadastrar galpão'
    click_on 'Criar Galpão'

    # Assert
    fields.each { |field| expect(page).to have_content "#{field} não pode ficar em branco." }
  end
end
