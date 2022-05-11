require 'rails_helper'

describe 'Usuário vê modelos de produto' do
  it 'a partir do menu de navegação' do
    # Arrange

    # Act
    visit root_path
    within 'nav' do
      click_on 'Modelos de produto'
    end

    # Assert
    expect(current_path).to eq product_models_path
    within 'section#product_models' do
      expect(page).to have_content 'Modelos de produto'
    end
  end

  it 'e vê modelos cadastrados' do
    # Arrange
    acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                            registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                            email: 'contato@acme.com', phone: '')
    ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                         code: 'NOTE-MARCA-123456789', supplier: acme)
    ProductModel.create!(name: 'Tablet', weight: 1_000, height: 10, width: 8, depth: 1,
                         code: 'TABLET-MARCA-1234567', supplier: acme)
    index_content = ['Notebook', 'Código: NOTE-MARCA-123456789', 'Tablet', 'Código: TABLET-MARCA-1234567']

    # Act
    visit root_path
    click_on 'Modelos de produto'

    # Assert
    index_content.each { |content| expect(page).to have_content content }
    expect(page).to have_content 'Fornecedor: ACME', count: 2
  end

  it 'e não existem modelos cadastrados' do
    # Arrange
    
    # Act
    visit root_path
    click_on 'Modelos de produto'

    # Assert
    expect(page).to have_content 'Não existem modelos cadastrados.'
  end
end
