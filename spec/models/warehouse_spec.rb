require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'falso quando nome está vazio' do
        warehouse = Warehouse.new(name: '', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                  state: 'RJ', cep: '20000-000', area: 10_000)

        warehouse.valid?

        expect(warehouse.errors.full_messages.length).to eq 1
        expect(warehouse.errors.full_messages[0]).to eq 'Nome não pode ficar em branco'
      end

      it 'falso quando descrição está vazia' do
        warehouse = Warehouse.new(name: 'Rio', description: '', code: 'RIO', city: 'Rio de Janeiro',
                                  state: 'RJ', cep: '20000-000', area: 10_000)

        warehouse.valid?

        expect(warehouse.errors.full_messages.length).to eq 1
        expect(warehouse.errors.full_messages[0]).to eq 'Descrição não pode ficar em branco'
      end

      it 'falso quando código está vazio' do
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: '', city: 'Rio de Janeiro',
                                  state: 'RJ', cep: '20000-000', area: 10_000)

        warehouse.valid?

        expect(warehouse.errors.full_messages.length).to eq 1
        expect(warehouse.errors.full_messages[0]).to eq 'Código não pode ficar em branco'
      end

      it 'falso quando cidade está vazia' do
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: '',
                                  state: 'RJ', cep: '20000-000', area: 10_000)

        warehouse.valid?

        expect(warehouse.errors.full_messages.length).to eq 1
        expect(warehouse.errors.full_messages[0]).to eq 'Cidade não pode ficar em branco'
      end

      it 'falso quando estado está vazio' do
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                  state: '', cep: '20000-000', area: 10_000)

        warehouse.valid?

        expect(warehouse.errors.full_messages.length).to eq 1
        expect(warehouse.errors.full_messages[0]).to eq 'Estado não pode ficar em branco'
      end

      it 'falso quando CEP está vazio' do
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                  state: 'RJ', cep: '', area: 10_000)

        warehouse.valid?

        expect(warehouse.errors.full_messages.length).to eq 2
        expect(warehouse.errors.full_messages[0]).to eq 'CEP não pode ficar em branco'
        expect(warehouse.errors.full_messages[1]).to eq 'CEP não é válido'
      end

      it 'falso quando área está vazia' do
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                  state: 'RJ', cep: '20000-000', area: '')

        warehouse.valid?

        expect(warehouse.errors.full_messages.length).to eq 1
        expect(warehouse.errors.full_messages[0]).to eq 'Área não pode ficar em branco'
      end
    end

    context 'formato' do
      it 'falso quando formato do CEP é incorreto' do
        warehouses = []
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: '12345678', area: 10_000)
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: 'ABCDEF-GHI', area: 10_000)
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: '1234-567', area: 10_000)
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: '12345-67', area: 10_000)
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: '12345-6789', area: 10_000)
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: '123456-789', area: 10_000)

        warehouses.each { |warehouse| warehouse.valid? }

        warehouses.each { |warehouse| expect(warehouse.errors.full_messages.length).to eq 1 }
        warehouses.each { |warehouse| expect(warehouse.errors.full_messages[0]).to eq 'CEP não é válido' }
      end
    end

    context 'singularidade' do
      it 'falso quando nome já foi cadastrado' do
        Warehouse.create!(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                          state: 'RJ', cep: '20000-000', area: 10_000)
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão de SP', code: 'SAO', city: 'São Paulo',
                                  state: 'SP', cep: '10000-000', area: 8_000)

        warehouse.valid?

        expect(warehouse.errors.full_messages.length).to eq 1
        expect(warehouse.errors.full_messages[0]).to eq 'Nome já está em uso'
      end

      it 'falso quando código já foi cadastrado' do
        Warehouse.create!(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                          state: 'RJ', cep: '20000-000', area: 10_000)
        warehouse = Warehouse.new(name: 'São Paulo', description: 'Galpão de SP', code: 'RIO', city: 'São Paulo',
                                  state: 'SP', cep: '10000-000', area: 8_000)

        warehouse.valid?

        expect(warehouse.errors.full_messages.length).to eq 1
        expect(warehouse.errors.full_messages[0]).to eq 'Código já está em uso'
      end
    end
  end
end
