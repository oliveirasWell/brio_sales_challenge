# frozen_string_literal: true

module SalesTaxes
  module Rules
    BASIC_RATE = BigDecimal("0.10")
    IMPORT_RATE = BigDecimal("0.05")

    EXEMPT_PRODUCTS = %w[book chocolate pill].freeze
    EXEMPT_PATTERN = /\b(?:#{EXEMPT_PRODUCTS.join("|")})s?\b/i

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
