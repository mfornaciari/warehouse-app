require 'rails_helper'

describe 'Usuário visita tela de fornecedores' do
  it 'a partir do menu de navegação' do
    visit root_path
    find('nav').click_on 'Fornecedores'

    expect(current_path).to eq suppliers_path
    within 'section#suppliers' do
      expect(page).to have_content 'Fornecedores'
    end
  end

  it 'e volta para tela inicial' do
    visit root_path
    find('nav').click_on 'Fornecedores'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  it 'e vê fornecedores cadastrados' do
    Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: 1_234_567_890_123,
                     address: 'Avenida A, n. 10', city: 'Natal', state: 'RN', cep: '12345-678',
                     email: 'contato@acme.com', phone: '91234-5678')
    Supplier.create!(brand_name: 'Stark', corporate_name: 'Stark Industries Brasil Ltda.',
                     registration_number: 1_234_567_890_321, address: '', city: '', state: '', cep: '',
                     email: 'contato@stark.com.br', phone: '')

    visit root_path
    find('nav').click_on 'Fornecedores'

    within('section#suppliers') do
      expect(page).to have_content 'ACME'
      expect(page).to have_content 'Stark'
    end
  end

  it 'e não existem fornecedores cadastrados' do
    visit root_path
    find('nav').click_on 'Fornecedores'

    within('section#suppliers') do
      expect(page).to have_content 'Não existem fornecedores cadastrados.'
    end
  end
end
