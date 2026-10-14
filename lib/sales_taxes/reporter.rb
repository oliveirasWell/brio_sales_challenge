# frozen_string_literal: true

module SalesTaxes
  class Reporter
    def report(result)
      lines = result.lines.map { |line| "#{line.item.quantity} #{line.item.name}: #{money(line.total)}" }
      lines << "Sales Taxes: #{money(result.sales_taxes)}"
      lines << "Total: #{money(result.total)}"
      "#{lines.join("\n")}\n"
    end

    private

    def money(amount) = format("%.2f", amount)
  end
end
