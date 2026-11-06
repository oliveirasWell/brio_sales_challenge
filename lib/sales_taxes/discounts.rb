# frozen_string_literal: true

module SalesTaxes
  module Discounts
    CATEGORY_DISCOUNTS = {
      Item::Category::EXEMPT => BigDecimal("0.10"),
      Item::Category::EVIL => BigDecimal("0.0"),
      Item::Category::GENERAL => BigDecimal("0.0")
    }.freeze


    module_function

    def rate_for(item)  = CATEGORY_DISCOUNTS.fetch(item.category)
  end
end
