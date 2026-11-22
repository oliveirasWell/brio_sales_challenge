# frozen_string_literal: true

require "bigdecimal"

require_relative "sales_taxes/item"
require_relative "sales_taxes/receipt"
require_relative "sales_taxes/rules"
require_relative "sales_taxes/parser"
require_relative "sales_taxes/calculator"
require_relative "sales_taxes/reporter"

module SalesTaxes
  def self.receipt_for(input)
    items = Parser.new.parse(input)
    receipt = Calculator.new.calculate(items)

    Reporter.new.report(receipt)
  end
end
