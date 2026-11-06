# frozen_string_literal: true

RSpec.describe SalesTaxes do
  it "prints the receipt for input 1" do
    input = <<~INPUT
      2 book at 12.49
      1 music CD at 14.99
      1 chocolate bar at 0.85
    INPUT

    expect(described_class.receipt_for(input)).to eq(<<~RECEIPT)
      2 book: 22.48
      1 music CD: 16.49
      1 chocolate bar: 0.75
      Sales Taxes: 1.50
      Total: 39.72
    RECEIPT
  end

  it "prints the receipt for input 2" do
    input = <<~INPUT
      1 imported box of chocolates at 10.00
      1 imported bottle of perfume at 47.50
    INPUT

    expect(described_class.receipt_for(input)).to eq(<<~RECEIPT)
      1 imported box of chocolates: 9.45
      1 imported bottle of perfume: 54.65
      Sales Taxes: 7.60
      Total: 64.10
    RECEIPT
  end

  it "prints the receipt for input 3" do
    input = <<~INPUT
      1 imported bottle of perfume at 27.99
      1 bottle of perfume at 18.99
      1 packet of headache pills at 9.75
      3 imported boxes of chocolates at 11.25
    INPUT

    expect(described_class.receipt_for(input)).to eq(<<~RECEIPT)
      1 imported bottle of perfume: 32.19
      1 bottle of perfume: 20.89
      1 packet of headache pills: 8.75
      3 imported boxes of chocolates: 31.95
      Sales Taxes: 7.75
      Total: 93.78
    RECEIPT
  end
end
