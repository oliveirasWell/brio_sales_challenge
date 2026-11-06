# frozen_string_literal: true

module SalesTaxes
  class Calculator
    ROUNDING_STEP = BigDecimal("0.05")

    def calculate(items)
      lines = items.map { create_line(it)}

      Receipt.new(lines: lines)
    end

    private

    def create_line(item)
      discount = unit_discount(item) * item.quantity
      discounted_price = item.unit_price - unit_discount(item)
      tax = unit_tax(discounted_price, item) * item.quantity

      Receipt::Line.new(item: item, discount: discount, tax: tax)
    end

    def unit_discount(item) = round_up(item.unit_price * Discounts.rate_for(item))
    def unit_tax(discounted_price, item) = round_up(discounted_price * Rules.rate_for(item))
    def round_up(amount) = (amount / ROUNDING_STEP).ceil * ROUNDING_STEP
  end
end
