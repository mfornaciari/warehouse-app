require 'rails_helper'

describe 'Usuário cadastra um galpão' do
  it 'a partir da tela inicial' do
    fields = %w[Nome Descrição Código Cidade Estado CEP Área]

    visit root_path
    click_on 'Cadastrar galpão'

    fields.each { |field| expect(page).to have_field field }
  end

  it 'com sucesso' do
    fields_and_content = { 'Nome': 'Aeroporto SP', 'Descrição': 'Galpão destinado para cargas internacionais.',
                           'Código': 'GRU', 'Cidade': 'Guarulhos', 'Estado': 'SP', 'CEP': '15000-000',
                           'Área': '100000' }
    index_content = ['Galpão cadastrado com sucesso.', 'Aeroporto SP', 'Código: GRU', 'Cidade: Guarulhos',
                     'Área: 100000 m2']

    visit root_path
    click_on 'Cadastrar galpão'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Galpão'

    expect(current_path).to eq root_path
    index_content.each { |content| expect(page).to have_content content }
  end

  it 'com dados incompletos' do
    blank_fields = %w[Descrição Código Cidade Estado CEP Área]

    visit root_path
    click_on 'Cadastrar galpão'
    fill_in 'Nome', with: 'Rio'
    click_on 'Criar Galpão'

    expect(page).to have_content 'Galpão não cadastrado.'
    blank_fields.each { |field| expect(page).to have_content "#{field} não pode ficar em branco." }
    expect(page).to have_field 'Nome', with: 'Rio'
    expect(page).not_to have_content 'CEP não é válido.'
  end

  it 'com dados inválidos' do
    Warehouse.create!(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                      state: 'RJ', cep: '20000-000', area: 10_000)
    fields_and_content = { 'Nome': 'Rio', 'Descrição': 'Galpão do Rio.', 'Código': 'RIO', 
                           'Cidade': 'Rio de Janeiro', 'Estado': 'RJ', 'CEP': '2', 'Área': '100000' }

    visit root_path
    click_on 'Cadastrar galpão'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Galpão'

    expect(page).to have_content 'Galpão não cadastrado.'
    expect(page).to have_content 'Nome já está em uso.'
    expect(page).to have_content 'Código já está em uso.'
    expect(page).to have_content 'CEP não é válido.'
  end
end
