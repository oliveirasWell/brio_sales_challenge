# frozen_string_literal: true

RSpec.describe SalesTaxes::Calculator do
  subject(:calculator) { described_class.new }

  def tax_for(quantity, name, price)
    item = SalesTaxes::Item.new(quantity:, name:, unit_price: BigDecimal(price))
    calculator.calculate([item]).sales_taxes
  end

  it "rounds tax up to the nearest 0.05" do
    expect(tax_for(1, "imported box of chocolates", "11.25")).to eq(BigDecimal("0.60"))
  end

  it "keeps tax that is already a multiple of 0.05" do
    expect(tax_for(1, "imported book", "1.00")).to eq(BigDecimal("0.05"))
  end

  it "rounds per unit before multiplying by quantity" do
    expect(tax_for(3, "imported boxes of chocolates", "11.25")).to eq(BigDecimal("1.80"))
  end

  it "charges no tax on a free item" do
    expect(tax_for(1, "music CD", "0.00")).to eq(0)
  end
end
