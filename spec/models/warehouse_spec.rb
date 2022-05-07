require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'falso quando nome está vazio' do
        # Arrange
        warehouse = Warehouse.new(name: '', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                  state: 'RJ', cep: '20000-000', area: 10_000)

        # Act

        # Assert
        expect(warehouse).not_to be_valid
      end

      it 'falso quando descrição está vazia' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', description: '', code: 'RIO', city: 'Rio de Janeiro',
                                  state: 'RJ', cep: '20000-000', area: 10_000)

        # Act

        # Assert
        expect(warehouse).not_to be_valid
      end

      it 'falso quando código está vazio' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: '', city: 'Rio de Janeiro',
                                  state: 'RJ', cep: '20000-000', area: 10_000)

        # Act

        # Assert
        expect(warehouse).not_to be_valid
      end

      it 'falso quando cidade está vazia' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: '',
                                  state: 'RJ', cep: '20000-000', area: 10_000)

        # Act

        # Assert
        expect(warehouse).not_to be_valid
      end

      it 'falso quando estado está vazio' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                  state: '', cep: '20000-000', area: 10_000)

        # Act

        # Assert
        expect(warehouse).not_to be_valid
      end

      it 'falso quando CEP está vazio' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                  state: 'RJ', cep: '', area: 10_000)

        # Act

        # Assert
        expect(warehouse).not_to be_valid
      end

      it 'falso quando área está vazia' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                  state: 'RJ', cep: '20000-000', area: '')

        # Act

        # Assert
        expect(warehouse).not_to be_valid
      end
    end

    context 'singularidade' do
      it 'falso quando nome já foi cadastrado' do
        # Arrange
        Warehouse.create(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                         state: 'RJ', cep: '20000-000', area: 10_000)
        warehouse2 = Warehouse.new(name: 'Rio', description: 'Galpão de SP', code: 'SAO', city: 'São Paulo',
                                   state: 'SP', cep: '10000-000', area: 8_000)

        # Act

        # Assert
        expect(warehouse2).not_to be_valid
      end

      it 'falso quando código já foi cadastrado' do
        # Arrange
        Warehouse.create(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                         state: 'RJ', cep: '20000-000', area: 10_000)
        warehouse2 = Warehouse.new(name: 'São Paulo', description: 'Galpão de SP', code: 'RIO', city: 'São Paulo',
                                   state: 'SP', cep: '10000-000', area: 8_000)

        # Act

        # Assert
        expect(warehouse2).not_to be_valid
      end
    end

    context 'formato' do
      it 'falso quando formato do CEP é incorreto' do
        # Arrange
        warehouses = []
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: '20000000', area: 10_000)
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: 'ABCDEF-GHI', area: 10_000)
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: '2000-000', area: 10_000)
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: '20000-00', area: 10_000)
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: '20000-0000', area: 10_000)
        warehouses << Warehouse.new(name: 'Rio', description: 'Galpão do Rio', code: 'RIO', city: 'Rio de Janeiro',
                                    state: 'RJ', cep: '200000-000', area: 10_000)

        # Act

        # Assert
        warehouses.each { |warehouse| expect(warehouse).not_to be_valid }
      end
    end
  end
end
