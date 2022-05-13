require 'rails_helper'

describe 'Usuário remove um galpão' do
  it 'com sucesso' do
    Warehouse.create!(name: 'Rio', description: 'Galpão da cidade do Rio.', code: 'SDU', city: 'Rio de Janeiro',
                      state: 'RJ', cep: '20000-000', area: 60_000)
    Warehouse.create!(name: 'Maceió', description: 'Galpão da cidade de Maceió.', code: 'MCZ', city: 'Maceió',
                      state: 'AL', cep: '30000-000', area: 50_000)
    rio_content = ['Rio', 'Código: SDU', 'Cidade: Rio de Janeiro', '60000 m2']
    maceio_content = ['Maceió', 'Código: MCZ', 'Cidade: Maceió', '50000 m2']

    visit root_path
    click_on 'Rio'
    click_on 'Remover'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão removido com sucesso.'
    rio_content.each { |content| expect(page).not_to have_content content }
    maceio_content.each { |content| expect(page).to have_content content }
  end
end
