# frozen_string_literal: true

module SalesTaxes
  class Calculator
    ROUNDING_STEP = BigDecimal("0.05")

    class Line
      attr_reader :item, :tax

      def initialize(item:, tax:)
        @item = item
        @tax = tax
        freeze
      end

      def total = (item.unit_price * item.quantity) + tax
    end

    class Result
      attr_reader :lines

      def initialize(lines:)
        @lines = lines.freeze
        freeze
      end

      def sales_taxes = lines.sum(BigDecimal(0), &:tax)
      def total = lines.sum(BigDecimal(0), &:total)
    end

    def initialize(rules: Rules)
      @rules = rules
    end

    def calculate(items)
      Result.new(lines: items.map { Line.new(item: it, tax: unit_tax(it) * it.quantity) })
    end

    private

    def unit_tax(item) = round_up(item.unit_price * @rules.rate_for(item))

    def round_up(amount) = (amount / ROUNDING_STEP).ceil * ROUNDING_STEP
  end
end
