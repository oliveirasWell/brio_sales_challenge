# frozen_string_literal: true

module SalesTaxes
  class ParseError < StandardError; end

  # Turns basket lines such as "1 imported box of chocolates at 10.00" into Items.
  class Parser
    LINE_FORMAT = /\A(?<quantity>[1-9]\d*) (?<name>.+) at (?<price>\d+\.\d{2})\z/

    def parse(input)
      lines = input.each_line(chomp: true).map(&:strip).reject(&:empty?)
      raise ParseError, "Basket is empty" if lines.empty?

      lines.map { parse_line(_1) }
    end

    private

    def parse_line(line)
      match = LINE_FORMAT.match(line) or raise ParseError, "Invalid line: #{line.inspect}"

      Item.new(quantity: Integer(match[:quantity]), name: match[:name], unit_price: BigDecimal(match[:price]))
    end
  end
end
