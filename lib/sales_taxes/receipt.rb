# frozen_string_literal: true

module SalesTaxes
  class Receipt
    class Line
      attr_reader :item, :tax

      def initialize(item:, tax:)
        @item = item
        @tax = tax
        freeze
      end

      def total = (item.unit_price * item.quantity) + tax
    end

    attr_reader :lines

    def initialize(lines:)
      @lines = lines.freeze
      freeze
    end

    def sales_taxes = lines.sum(BigDecimal(0), &:tax)
    def total = lines.sum(BigDecimal(0), &:total)
  end
end
