# frozen_string_literal: true

module SalesTaxes
  class Reporter
    def report(result)
      lines = result.lines.map { "#{_1.item.quantity} #{_1.item.name}: #{money(_1.total)}" }
      lines << "Sales Taxes: #{money(result.sales_taxes)}"
      lines << "Total: #{money(result.total)}"
      "#{lines.join("\n")}\n"
    end

    private

    def money(amount) = format("%.2f", amount)
  end
end
