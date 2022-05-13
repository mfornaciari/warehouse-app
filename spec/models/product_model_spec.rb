require 'rails_helper'

RSpec.describe ProductModel, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'falso quando nome está vazio' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        product_model = ProductModel.new(name: '', weight: 2_000, height: 15, width: 25, depth: 10,
                                         code: 'NOTE-MARCA-123456789', supplier: acme)

        product_model.valid?

        expect(product_model.errors.full_messages.length).to eq 1
        expect(product_model.errors.full_messages[0]).to eq 'Nome não pode ficar em branco'
      end

      it 'falso quando peso está vazio' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        product_model = ProductModel.new(name: 'Notebook', weight: '', height: 15, width: 25, depth: 10,
                                         code: 'NOTE-MARCA-123456789', supplier: acme)

        product_model.valid?

        expect(product_model.errors.full_messages.length).to eq 1
        expect(product_model.errors.full_messages[0]).to eq 'Peso não pode ficar em branco'
      end

      it 'falso quando altura está vazia' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        product_model = ProductModel.new(name: 'Notebook', weight: 2_000, height: '', width: 25, depth: 10,
                                         code: 'NOTE-MARCA-123456789', supplier: acme)

        product_model.valid?

        expect(product_model.errors.full_messages.length).to eq 1
        expect(product_model.errors.full_messages[0]).to eq 'Altura não pode ficar em branco'
      end

      it 'falso quando largura está vazia' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        product_model = ProductModel.new(name: 'Notebook', weight: 2_000, height: 15, width: '', depth: 10,
                                         code: 'NOTE-MARCA-123456789', supplier: acme)

        product_model.valid?

        expect(product_model.errors.full_messages.length).to eq 1
        expect(product_model.errors.full_messages[0]).to eq 'Largura não pode ficar em branco'
      end

      it 'falso quando profundidade está vazia' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        product_model = ProductModel.new(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: '',
                                         code: 'NOTE-MARCA-123456789', supplier: acme)

        product_model.valid?

        expect(product_model.errors.full_messages.length).to eq 1
        expect(product_model.errors.full_messages[0]).to eq 'Profundidade não pode ficar em branco'
      end

      it 'falso quando código está vazio' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        product_model = ProductModel.new(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                                         code: '', supplier: acme)

        product_model.valid?

        expect(product_model.errors.full_messages.length).to eq 2
        expect(product_model.errors.full_messages[0]).to eq 'Código não pode ficar em branco'
      end

      it 'falso quando fornecedor está vazio' do
        product_model = ProductModel.new(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                                         code: 'NOTE-MARCA-123456789', supplier: nil)

        product_model.valid?

        expect(product_model.errors.full_messages.length).to eq 1
        expect(product_model.errors.full_messages[0]).to eq 'Fornecedor é obrigatório(a)'
      end
    end

    context 'valor' do
      it 'falso quando peso <= 0' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        product_models = []
        product_models << ProductModel.new(name: 'Notebook', weight: 0, height: 15, width: 25, depth: 10,
                                           code: 'NOTE-MARCA-123456789', supplier: acme)
        product_models << ProductModel.new(name: 'Tablet', weight: -1, height: 10, width: 8, depth: 1,
                                           code: 'NOTE-MARCA-123456789', supplier: acme)

        product_models.each(&:valid?)

        product_models.each do |product_model|
          expect(product_model.errors.full_messages.length).to eq 1
          expect(product_model.errors.full_messages[0]).to eq 'Peso deve ser maior que 0'
        end
      end

      it 'falso quando altura <= 0' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        product_models = []
        product_models << ProductModel.new(name: 'Notebook', weight: 2_000, height: 0, width: 25, depth: 10,
                                           code: 'NOTE-MARCA-123456789', supplier: acme)
        product_models << ProductModel.new(name: 'Tablet', weight: 500, height: -1, width: 8, depth: 1,
                                           code: 'NOTE-MARCA-123456789', supplier: acme)

        product_models.each(&:valid?)

        product_models.each do |product_model|
          expect(product_model.errors.full_messages.length).to eq 1
          expect(product_model.errors.full_messages[0]).to eq 'Altura deve ser maior que 0'
        end
      end

      it 'falso quando largura <= 0' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        product_models = []
        product_models << ProductModel.new(name: 'Notebook', weight: 2_000, height: 15, width: 0, depth: 10,
                                           code: 'NOTE-MARCA-123456789', supplier: acme)
        product_models << ProductModel.new(name: 'Tablet', weight: 500, height: 10, width: -1, depth: 1,
                                           code: 'NOTE-MARCA-123456789', supplier: acme)

        product_models.each(&:valid?)

        product_models.each do |product_model|
          expect(product_model.errors.full_messages.length).to eq 1
          expect(product_model.errors.full_messages[0]).to eq 'Largura deve ser maior que 0'
        end
      end

      it 'falso quando profundidade <= 0' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        product_models = []
        product_models << ProductModel.new(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 0,
                                           code: 'NOTE-MARCA-123456789', supplier: acme)
        product_models << ProductModel.new(name: 'Tablet', weight: 500, height: 10, width: 8, depth: -1,
                                           code: 'NOTE-MARCA-123456789', supplier: acme)

        product_models.each(&:valid?)

        product_models.each do |product_model|
          expect(product_model.errors.full_messages.length).to eq 1
          expect(product_model.errors.full_messages[0]).to eq 'Profundidade deve ser maior que 0'
        end
      end
    end

    context 'formato' do
      it 'falso quando formato do código é incorreto' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        invalid_models = []
        invalid_models << ProductModel.new(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                                           code: 'A', supplier: acme)
        invalid_models << ProductModel.new(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                                           code: '123456789012345678901234567890', supplier: acme)
        invalid_models << ProductModel.new(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                                           code: '1 2 3 4 5 6 7 8 9 0 ', supplier: acme)
        valid_model = ProductModel.new(name: 'Tablet', weight: 1_000, height: 10, width: 8, depth: 1,
                                       code: 'NOTE-MARCA-123456789', supplier: acme)

        invalid_models.each(&:valid?)

        invalid_models.each do |model|
          expect(model.errors.full_messages.length).to eq 1
          expect(model.errors.full_messages[0]).to eq 'Código não é válido'
        end
        expect(valid_model).to be_valid
      end
    end

    context 'singularidade' do
      it 'falso quando código já foi cadastrado' do
        acme = Supplier.create!(brand_name: 'ACME', corporate_name: 'ACME Ltda.',
                                registration_number: 1_234_567_890_123, address: '', city: '', state: '', cep: '',
                                email: 'contato@acme.com', phone: '')
        ProductModel.create!(name: 'Notebook', weight: 2_000, height: 15, width: 25, depth: 10,
                             code: 'NOTE-MARCA-123456789', supplier: acme)
        tablet = ProductModel.new(name: 'Tablet', weight: 1_000, height: 10, width: 8, depth: 1,
                                  code: 'NOTE-MARCA-123456789', supplier: acme)

        tablet.valid?

        expect(tablet.errors.full_messages.length).to eq 1
        expect(tablet.errors.full_messages[0]).to eq 'Código já está em uso'
      end
    end
  end
end
