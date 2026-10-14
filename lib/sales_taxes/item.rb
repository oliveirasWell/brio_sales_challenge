# frozen_string_literal: true

module SalesTaxes
  Item = Data.define(:quantity, :name, :unit_price) do
    def imported? = name.match?(/\bimported\b/i)
  end
end
