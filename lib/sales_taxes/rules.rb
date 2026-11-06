# frozen_string_literal: true

module SalesTaxes
  module Rules
    Tax = Data.define(:rate, :applies_to) do
      def rate_for(item) = applies_to.call(item) ? rate : BigDecimal(0)
    end

    EXEMPT_PATTERN = /\b(?:book|chocolate|pill)s?\b/i

    BASIC = Tax.new(rate: BigDecimal("0.10"), applies_to: ->(item) { !item.name.match?(EXEMPT_PATTERN) })
    IMPORT = Tax.new(rate: BigDecimal("0.05"), applies_to: :imported?.to_proc)

    TAXES = [BASIC, IMPORT].freeze

    module_function

    def rate_for(item) = TAXES.sum(BigDecimal(0)) { it.rate_for(item) }
  end
end
