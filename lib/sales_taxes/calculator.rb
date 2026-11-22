# frozen_string_literal: true

module SalesTaxes
  class Calculator
    ROUNDING_STEP = BigDecimal("0.05")

    def calculate(items)
      Receipt.new(lines: items.map { Receipt::Line.new(item: it, tax: unit_tax(it) * it.quantity) })
    end

    private

    def unit_tax(item) = round_up(item.unit_price * Rules.rate_for(item))

    def round_up(amount) = (amount / ROUNDING_STEP).ceil * ROUNDING_STEP
  end
end
