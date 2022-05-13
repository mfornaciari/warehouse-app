require 'rails_helper'

describe 'Usuário visita tela de detalhes de um fornecedor' do
  it 'e vê informações adicionais' do
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: 'Avenida A, 10', city: 'Natal', state: 'RN', cep: '12345-678',
                     email: 'contato@acme.com', phone: '91234-5678')
    details_content = ['Nome fantasia: ACME', 'Razão social: ACME Ltda.', 'CNPJ: 1234567890123',
                       'Endereço: Avenida A, 10 - Natal/RN. CEP: 12345-678', 'E-mail: contato@acme.com',
                       'Telefone: 91234-5678']

    visit root_path
    find('nav').click_on 'Fornecedores'
    find('section#suppliers').click_on 'ACME'

    details_content.each { |content| expect(page).to have_content content }
  end

  it 'e não vê detalhes não informados' do
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')
    empty_content = %w[Endereço CEP Telefone]

    visit root_path
    find('nav').click_on 'Fornecedores'
    find('section#suppliers').click_on 'ACME'

    empty_content.each { |content| expect(page).not_to have_content content }
  end

  it 'e volta para a tela inicial' do
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: 'Avenida A, 10', city: 'Natal', state: 'RN', cep: '12345-678',
                     email: 'contato@acme.com', phone: '91234-5678')

    visit root_path
    find('nav').click_on 'Fornecedores'
    find('section#suppliers').click_on 'ACME'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
