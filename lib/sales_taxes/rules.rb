# frozen_string_literal: true

module SalesTaxes
  module Rules
    CATEGORY_RATES = {
      Item::Category::EXEMPT => BigDecimal("0"),
      Item::Category::EVIL => BigDecimal("0.20"),
      Item::Category::GENERAL => BigDecimal("0.10")
    }.freeze

    IMPORT_RATE = BigDecimal("0.05")

    module_function

    def rate_for(item)
      category_rate = CATEGORY_RATES.fetch(item.category)
      import_rate = (item.imported? ? IMPORT_RATE : 0)

      category_rate + import_rate
    end
  end
end
