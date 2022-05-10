require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'falso quando nome fantasia está vazio' do
        # Arrange
        supplier = Supplier.new(brand_name: '', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, email: 'contato@acme.com')

        # Act

        # Assert
        expect(supplier).not_to be_valid
      end

      it 'falso quando razão social está vazia' do
        supplier = Supplier.new(brand_name: 'ACME', corporate_name: '',
                                registration_number: 1_234_567_890_123, email: 'contato@acme.com')

        # Act

        # Assert
        expect(supplier).not_to be_valid
      end

      it 'falso quando CNPJ está vazio' do
        supplier = Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: '', email: 'contato@acme.com')

        # Act

        # Assert
        expect(supplier).not_to be_valid
      end

      it 'falso quando email está vazio' do
        supplier = Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, email: '')

        # Act

        # Assert
        expect(supplier).not_to be_valid
      end
    end

    context 'singularidade' do
      it 'falso quando CNPJ já foi cadastrado' do
        # Arrange
        Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                         registration_number: 1_234_567_890_123, email: 'contato@acme.com')
        supplier2 = Supplier.new(brand_name: 'Stark', corporate_name: 'Stark Industries Brasil Ltda.',
                                 registration_number: 1_234_567_890_123, email: 'contato@stark.com.br')

        # Act

        # Assert
        expect(supplier2).not_to be_valid
      end
    end

    context 'formato' do
      it 'falso quando formato do CNPJ é incorreto' do
        # Arrange
        invalid_suppliers = []
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 'ABCDEFGHIJKLM', email: 'contato@acme.com')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 12_345_678_901_234, email: 'contato@acme.com')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 123_456_789_012, email: 'contato@acme.com')

        valid_supplier = Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                      registration_number: 1_234_567_890_123, email: 'contato@acme.com')

        # Act

        # Assert
        invalid_suppliers.each { |supplier| expect(supplier).not_to be_valid }
        expect(valid_supplier).to be_valid
      end

      it 'falso quando formato do CEP é incorreto' do
        # Arrange
        invalid_suppliers = []
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_120, email: 'contato@acme.com',
                                          cep: '12345678')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_121, email: 'contato@acme.com',
                                          cep: 'ABCDEF-GHI')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_122, email: 'contato@acme.com',
                                          cep: '1234-567')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_123, email: 'contato@acme.com',
                                          cep: '12345-67')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_124, email: 'contato@acme.com',
                                          cep: '12345-5678')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_125, email: 'contato@acme.com',
                                          cep: '123456-789')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_126, email: 'contato@acme.com',
                                          cep: 'A12345-678')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_127, email: 'contato@acme.com',
                                          cep: '12345-789A')

        valid_supplier = Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                      registration_number: 1_234_567_890_129, email: 'contato@acme.com',
                                      cep: '01234-567')

        # Act

        # Assert
        invalid_suppliers.each { |supplier| expect(supplier).not_to be_valid }
        expect(valid_supplier).to be_valid
      end
    end
  end
end
