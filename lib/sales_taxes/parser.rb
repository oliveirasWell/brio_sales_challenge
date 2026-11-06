# frozen_string_literal: true

module SalesTaxes
  class ParseError < StandardError; end

  class Parser
    LINE_FORMAT = /\A(?<quantity>[1-9]\d*) (?<name>.+) at (?<price>\d+\.\d{2})\z/

    def parse(input)
      lines = input.each_line(chomp: true).map(&:strip).reject(&:empty?)
      raise ParseError, "Basket is empty" if lines.empty?

      lines.map { parse_line(it) }
    end

    private

    def parse_line(line)
      match = LINE_FORMAT.match(line) or raise ParseError, "Invalid line: #{line.inspect}"

      quantity, name, price = match.values_at(:quantity, :name, :price)

      Item.new(quantity: Integer(quantity), name:, unit_price: BigDecimal(price), category: Item::Category.for(name:))
    end
  end
end
