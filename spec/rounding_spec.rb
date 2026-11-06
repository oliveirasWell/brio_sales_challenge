# frozen_string_literal: true

RSpec.describe "Sales tax rounding" do
  def tax_for(unit_price, quantity: 1)
    item = SalesTaxes::Item.new(
      quantity:, name: "widget", unit_price: BigDecimal(unit_price), category: SalesTaxes::Item::Category::GENERAL
    )

    SalesTaxes::Calculator.new.calculate([item]).sales_taxes
  end

  {
    "14.99" => "1.50",
    "0.01" => "0.05",
    "0.51" => "0.10",
    "1.00" => "0.10",
    "0.50" => "0.05",
    "0.00" => "0.00"
  }.each do |price, tax|
    it "rounds 10% of #{price} up to #{tax}" do
      expect(tax_for(price)).to eq(BigDecimal(tax))
    end
  end

  it "rounds each unit before multiplying by quantity" do
    expect(tax_for("0.01", quantity: 3)).to eq(BigDecimal("0.15"))
  end
end
