# frozen_string_literal: true

module SalesTaxes
  class Item
    attr_reader :quantity, :name, :unit_price

    def initialize(quantity:, name:, unit_price:)
      @quantity = quantity
      @name = name.dup.freeze
      @unit_price = unit_price
      freeze
    end

    def imported? = name.match?(/\bimported\b/i)
  end
end
