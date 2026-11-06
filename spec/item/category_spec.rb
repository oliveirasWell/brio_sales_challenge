# frozen_string_literal: true

RSpec.describe SalesTaxes::Item::Category do
  {
    "book" => described_class::EXEMPT,
    "box of chocolates" => described_class::EXEMPT,
    "imported box of chocolates" => described_class::EXEMPT,
    "packet of headache pills" => described_class::EXEMPT,
    "Book" => described_class::EXEMPT,
    "packet of cigarettes" => described_class::EVIL,
    "packet of imported red-label-whiskey" => described_class::EVIL,
    "music CD" => described_class::GENERAL,
    "bottle of perfume" => described_class::GENERAL
  }.each do |name, category|
    it "classifies #{name.inspect} as #{category}" do
      expect(described_class.for(name:)).to eq(category)
    end
  end
end
