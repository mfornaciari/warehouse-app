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
    rio_content = ['Rio', 'Código: SDU', 'Cidade: Rio de Janeiro', '60000 m2']
    maceio_content = ['Maceió', 'Código: MCZ', 'Cidade: Maceió', '50000 m2']

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_content 'Não existem galpões cadastrados.'
    rio_content.each { |content| expect(page).to have_content content }
    maceio_content.each { |content| expect(page).to have_content content }
  end

  it 'e não existem galpões cadastrados' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).to have_content 'Não existem galpões cadastrados.'
  end
end
