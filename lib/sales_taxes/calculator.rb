# frozen_string_literal: true

module SalesTaxes
  # Applies tax rules to items and totals the basket.
  class Calculator
    ROUNDING_STEP = BigDecimal("0.05")

    Line = Data.define(:item, :tax) do
      def total = (item.unit_price * item.quantity) + tax
    end

    Result = Data.define(:lines) do
      def sales_taxes = lines.sum(BigDecimal(0), &:tax)
      def total = lines.sum(BigDecimal(0), &:total)
    end

    def initialize(rules: Rules)
      @rules = rules
    end

    def calculate(items)
      Result.new(lines: items.map { Line.new(item: _1, tax: unit_tax(_1) * _1.quantity) }.freeze)
    end

    private

    # Tax is rounded per unit, as the shelf price is the price of one unit.
    def unit_tax(item) = round_up(item.unit_price * @rules.rate_for(item))

    def round_up(amount) = (amount / ROUNDING_STEP).ceil * ROUNDING_STEP
  end
end
