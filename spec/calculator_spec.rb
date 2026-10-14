# frozen_string_literal: true

RSpec.describe SalesTaxes::Calculator do
  def sales_taxes(line) = described_class.new.calculate(SalesTaxes::Parser.new.parse(line)).sales_taxes

  {
    "1 imported box of chocolates at 11.25" => "0.60",
    "1 imported book at 1.00" => "0.05",
    "3 imported boxes of chocolates at 11.25" => "1.80",
    "1 music CD at 0.00" => "0.00",
    "1 Imported Book at 10.00" => "0.50"
  }.each do |line, tax|
    it "charges #{tax} sales tax on #{line.inspect}" do
      expect(sales_taxes(line)).to eq(BigDecimal(tax))
    end
  end
end
