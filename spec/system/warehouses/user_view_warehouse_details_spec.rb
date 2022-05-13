require 'rails_helper'

describe 'Usuário vê detalhes de um galpão' do
  it 'e vê informações adicionais' do
    Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', description: 'Galpão destinado para cargas internacionais.',
                      city: 'Guarulhos', state: 'SP', cep: '15000-000', area: 100_000)
    details_content = ['Aeroporto SP', 'Código: GRU', 'Galpão destinado para cargas internacionais.',
                       'Endereço: Guarulhos, SP. CEP: 15000-000', 'Área: 100000 m2']

    visit root_path
    click_on 'Aeroporto SP'

    details_content.each { |content| expect(page).to have_content content }
  end

  it 'e volta para a tela inicial' do
    Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', description: 'Galpão destinado para cargas internacionais.',
                      city: 'Guarulhos', state: 'SP', cep: '15000-000', area: 100_000)

    visit root_path
    click_on 'Aeroporto SP'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
