# frozen_string_literal: true

module SalesTaxes
  # A basket entry: how many units of a product, and the shelf price of one unit.
  Item = Data.define(:quantity, :name, :unit_price) do
    def imported? = name.match?(/\bimported\b/)
  end
end
