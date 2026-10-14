# frozen_string_literal: true

module SalesTaxes
  # Knows which tax rates apply to an item.
  module Rules
    BASIC_RATE = BigDecimal("0.10")
    IMPORT_RATE = BigDecimal("0.05")

    # Books, food and medical products are exempt from basic sales tax.
    EXEMPT_PRODUCTS = %w[book chocolate pill].freeze
    EXEMPT_PATTERN = /\b(?:#{EXEMPT_PRODUCTS.join("|")})s?\b/

    module_function

    def rate_for(item)
      rate = BigDecimal(0)
      rate += BASIC_RATE unless exempt?(item)
      rate += IMPORT_RATE if item.imported?
      rate
    end

    def exempt?(item) = item.name.match?(EXEMPT_PATTERN)
  end
end
