require 'rails_helper'

describe 'Usuário cadastra um fornecedor' do
  it 'a partir da tela inicial' do
    fields = ['Nome fantasia', 'Razão social', 'CNPJ', 'Endereço',
              'Cidade', 'Estado', 'CEP', 'E-mail', 'Telefone']

    visit root_path
    find('nav').click_on 'Fornecedores'
    click_on 'Cadastrar fornecedor'

    fields.each { |field| expect(page).to have_field field }
  end

  it 'com sucesso' do
    fields_and_content = { 'Nome fantasia': 'ACME', 'Razão social': 'ACME Ltda.', 'CNPJ': '1234567890123',
                           'Endereço': '', 'Cidade': '', 'Estado': '', 'CEP': '', 'E-mail': 'contato@acme.com',
                           'Telefone': '' }

    visit root_path
    find('nav').click_on 'Fornecedores'
    click_on 'Cadastrar fornecedor'
    fields_and_content.each_pair { |field, content| fill_in field, with: content }
    click_on 'Criar Fornecedor'

    expect(current_path).to eq suppliers_path
    expect(page).to have_content 'Fornecedor cadastrado com sucesso.'
    expect(page).to have_content 'ACME'
  end

  it 'com dados incompletos' do
    required_fields = ['Nome fantasia', 'Razão social', 'CNPJ', 'E-mail']

    visit root_path
    find('nav').click_on 'Fornecedores'
    click_on 'Cadastrar fornecedor'
    fill_in 'Cidade', with: 'Natal'
    click_on 'Criar Fornecedor'

    required_fields.each { |field| expect(page).to have_content "#{field} não pode ficar em branco." }
    expect(page).to have_field 'Cidade', with: 'Natal'
  end

  it 'com CNPJ inválido' do
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')

    visit root_path
    find('nav').click_on 'Fornecedores'
    click_on 'Cadastrar fornecedor'
    fill_in 'CNPJ', with: '123'
    click_on 'Criar Fornecedor'

    expect(page).to have_content 'CNPJ não é válido.'
  end

  it 'com CNPJ repetido' do
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')

    visit root_path
    find('nav').click_on 'Fornecedores'
    click_on 'Cadastrar fornecedor'
    fill_in 'CNPJ', with: '1234567890123'
    click_on 'Criar Fornecedor'

    expect(page).to have_content 'CNPJ já está em uso.'
  end
end
