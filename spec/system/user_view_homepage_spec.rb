require 'rails_helper'

describe 'Usuário visita tela inicial' do
  it 'e vê o nome da aplicação' do
    # Arrange

    # Act
    visit('/')

    # Assert
    expect(page).to have_content('Sistema de Galpões e Estoque')
  end

  it 'e vê os galpões cadastrados' do
    # Arrange
    rio = Warehouse.create(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000)
    maceio = Warehouse.create(name: 'Maceió', code: 'MCZ', city: 'Maceió', area: 50_000)
    warehouses = [rio, maceio]

    # Act
    visit('/')

    # Assert
    expect(page).not_to have_content('Não existem galpões cadastrados.')

    warehouses.each do |warehouse|
      expect(page).to have_content(warehouse.name)
      expect(page).to have_content("Código: #{warehouse.code}")
      expect(page).to have_content("Cidade: #{warehouse.city}")
      expect(page).to have_content("#{warehouse.area} m2")
    end
  end

  it 'e não existem galpões cadastrados' do
    # Arrange

    # Act
    visit('/')

    # Assert
    expect(page).to have_content('Não existem galpões cadastrados.')
  end
end
