require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'falso quando nome fantasia está vazio' do
        supplier = Supplier.new(brand_name: '', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')

        supplier.valid?

        expect(supplier.errors.full_messages.length).to eq 1
        expect(supplier.errors.full_messages[0]).to eq 'Nome fantasia não pode ficar em branco'
      end

      it 'falso quando razão social está vazia' do
        supplier = Supplier.new(brand_name: 'ACME', corporate_name: '', registration_number: 1_234_567_890_123,
                                address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')

        supplier.valid?

        expect(supplier.errors.full_messages.length).to eq 1
        expect(supplier.errors.full_messages[0]).to eq 'Razão social não pode ficar em branco'
      end

      it 'falso quando CNPJ está vazio' do
        supplier = Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.', registration_number: '',
                                address: '', city: '', state: '', cep: '', email: 'contato@acme.com', phone: '')

        supplier.valid?

        expect(supplier.errors.full_messages.length).to eq 2
        expect(supplier.errors.full_messages[0]).to eq 'CNPJ não pode ficar em branco'
      end

      it 'falso quando email está vazio' do
        supplier = Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: '', phone: '')

        supplier.valid?

        expect(supplier.errors.full_messages.length).to eq 1
        expect(supplier.errors.full_messages[0]).to eq 'E-mail não pode ficar em branco'
      end
    end

    context 'formato' do
      it 'falso quando formato do CNPJ é incorreto' do
        invalid_suppliers = []
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 'ABCDEFGHIJKLM', address: '', city: '', state: '',
                                          cep: '', email: 'contato@acme.com', phone: '')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 12_345_678_901_234, address: '', city: '', state: '',
                                          cep: '', email: 'contato@acme.com', phone: '')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1, address: '', city: '', state: '', cep: '',
                                          email: 'contato@acme.com', phone: '')
        valid_supplier = Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                      registration_number: 1_234_567_890_123, address: '', city: '', state: '',
                                      cep: '', email: 'contato@acme.com', phone: '')

        invalid_suppliers.each(&:valid?)

        invalid_suppliers.each do |supplier|
          expect(supplier.errors.full_messages.length).to eq 1
          expect(supplier.errors.full_messages[0]).to eq 'CNPJ não é válido'
        end
        expect(valid_supplier).to be_valid
      end

      it 'falso quando formato do CEP é incorreto' do
        invalid_suppliers = []
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_120, address: '', city: '', state: '',
                                          cep: '12345678', email: 'contato@acme.com', phone: '')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_121, address: '', city: '', state: '',
                                          cep: 'ABCDEF-GHI', email: 'contato@acme.com', phone: '')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_122, address: '', city: '', state: '',
                                          cep: '1234-567', email: 'contato@acme.com', phone: '')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_123, address: '', city: '', state: '',
                                          cep: '12345-67', email: 'contato@acme.com', phone: '')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_124, email: 'contato@acme.com',
                                          cep: '12345-5678')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_125, address: '', city: '', state: '',
                                          cep: '123456-789', email: 'contato@acme.com', phone: '')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_126, email: 'contato@acme.com',
                                          cep: 'A12345-678')
        invalid_suppliers << Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                          registration_number: 1_234_567_890_127, address: '', city: '', state: '',
                                          cep: '12345-789A', email: 'contato@acme.com', phone: '')
        valid_supplier = Supplier.new(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                      registration_number: 1_234_567_890_129, address: '', city: '', state: '',
                                      cep: '01234-567', email: 'contato@acme.com', phone: '')

        invalid_suppliers.each(&:valid?)

        invalid_suppliers.each do |supplier|
          expect(supplier.errors.full_messages.length).to eq 1
          expect(supplier.errors.full_messages[0]).to eq 'CEP não é válido'
        end
        expect(valid_supplier).to be_valid
      end
    end

    context 'singularidade' do
      it 'falso quando CNPJ já foi cadastrado' do
        Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                         registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                         email: 'contato@acme.com', phone: '')
        supplier = Supplier.new(brand_name: 'Stark', corporate_name: 'Stark Industries Brasil Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@stark.com.br', phone: '')

        supplier.valid?

        expect(supplier.errors.full_messages.length).to eq 1
        expect(supplier.errors.full_messages[0]).to eq 'CNPJ já está em uso'
      end
    end
  end
end
