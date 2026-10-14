# frozen_string_literal: true

RSpec.describe SalesTaxes::Parser do
  subject(:parser) { described_class.new }

  it "ignores blank lines" do
    items = parser.parse("\n1 book at 12.49\n\n")

    expect(items).to eq([SalesTaxes::Item.new(quantity: 1, name: "book", unit_price: BigDecimal("12.49"))])
  end

  it "rejects an empty basket" do
    expect { parser.parse("\n") }.to raise_error(SalesTaxes::ParseError, "Basket is empty")
  end

  [
    "book at 12.49",
    "0 book at 12.49",
    "1 book 12.49",
    "1 book at",
    "1 book at 12.5",
    "1 book at -12.49"
  ].each do |line|
    it "rejects #{line.inspect}" do
      expect { parser.parse(line) }.to raise_error(SalesTaxes::ParseError, "Invalid line: #{line.inspect}")
    end
  end
end
