require 'rails_helper'

describe 'Usuário edita um galpão' do
  it 'a partir da página de detalhes' do
    # Arrange
    Warehouse.create!(name: 'Rio', description: 'Galpão da cidade do Rio.', code: 'SDU', city: 'Rio de Janeiro',
                      state: 'RJ', cep: '20000-000', area: 60_000)
    fields_and_content = { 'Nome': 'Rio', 'Descrição': 'Galpão da cidade do Rio.', 'Código': 'SDU',
                           'Cidade': 'Rio de Janeiro', 'Estado': 'RJ', 'CEP': '20000-000', 'Área': '60000' }

    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'

    # Assert
    expect(page).to have_content 'Editar galpão'
    fields_and_content.each_pair { |field, content| expect(page).to have_field field, with: content }
  end

  it 'com sucesso' do
    # Arrange
    Warehouse.create!(name: 'Rio', description: 'Galpão da cidade do Rio.', code: 'SDU', city: 'Rio de Janeiro',
                      state: 'RJ', cep: '20000-000', area: 60_000)
    fields_and_content = { 'Nome': 'São Paulo', 'Descrição': 'Galpão da cidade de SP.', 'Código': 'SPA',
                           'Cidade': 'São Paulo', 'Estado': 'SP', 'CEP': '10000-000', 'Área': '100000' }
    details_content = ['Galpão atualizado com sucesso.', 'São Paulo', 'Código: SPA', 'Galpão da cidade de SP',
                       'Endereço: São Paulo, SP. CEP: 10000-000', 'Área: 100000 m2']

    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    click_on 'Atualizar Galpão'

    # Assert
    expect(current_path).to eq warehouse_path(1)
    details_content.each { |content| expect(page).to have_content content }
  end

  it 'com dados incompletos' do
    # Arrange
    Warehouse.create!(name: 'Rio', description: 'Galpão da cidade do Rio.', code: 'SDU', city: 'Rio de Janeiro',
                      state: 'RJ', cep: '20000-000', area: 60_000)
    fields = %w[Nome Descrição Código Cidade Estado CEP Área]

    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'
    fields.each { |field| fill_in field, with: '' }
    click_on 'Atualizar Galpão'

    # Assert
    expect(page).to have_content 'Galpão não atualizado.'
    fields.each { |field| expect(page).to have_content "#{field} não pode ficar em branco." }
    expect(page).not_to have_content 'CEP não é válido.'
  end

  it 'com dados inválidos' do
    # Arrange
    Warehouse.create!(name: 'Rio', description: 'Galpão da cidade do Rio.', code: 'SDU', city: 'Rio de Janeiro',
                      state: 'RJ', cep: '20000-000', area: 60_000)
    Warehouse.create!(name: 'São Paulo', description: 'Galpão da cidade de SP.', code: 'SPA', city: 'São Paulo',
                      state: 'SP', cep: '15000-000', area: 100_000)
    fields_and_content = { 'Nome': 'Rio', 'Código': 'SDU', 'CEP': '2' }

    # Act
    visit root_path
    click_on 'São Paulo'
    click_on 'Editar'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    click_on 'Atualizar Galpão'

    # Assert
    expect(page).to have_content 'Galpão não atualizado.'
    expect(page).to have_content 'Nome já está em uso.'
    expect(page).to have_content 'Código já está em uso.'
    expect(page).to have_content 'CEP não é válido.'
  end
end
