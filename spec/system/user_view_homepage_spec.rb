require 'rails_helper'

describe 'Usuário visita tela inicial' do
  it 'e vê o nome da aplicação' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).to have_content 'Sistema de Galpões e Estoque'
  end

  it 'e vê os galpões cadastrados' do
    # Arrange
    Warehouse.create(name: 'Rio', description: 'Galpão da cidade do Rio.', code: 'SDU', city: 'Rio de Janeiro',
                     state: 'RJ', cep: '20000-000', area: 60_000)
    Warehouse.create(name: 'Maceió', description: 'Galpão da cidade de Maceió.', code: 'MCZ', city: 'Maceió',
                     state: 'RJ', cep: '30000-000', area: 50_000)

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_content 'Não existem galpões cadastrados.'

    expect(page).to have_content 'Rio'
    expect(page).to have_content 'Código: SDU'
    expect(page).to have_content 'Cidade: Rio de Janeiro'
    expect(page).to have_content '60000 m2'

    expect(page).to have_content 'Maceió'
    expect(page).to have_content 'Código: MCZ'
    expect(page).to have_content 'Cidade: Maceió'
    expect(page).to have_content '50000 m2'
  end

  it 'e não existem galpões cadastrados' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).to have_content 'Não existem galpões cadastrados.'
  end
end
