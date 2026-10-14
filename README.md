# Sales Taxes

Prints shopping receipts with sales taxes for the
[Subscribe coding exercise](https://gist.github.com/safplatform/792314da6b54346594432f30d5868f36).

Plain Ruby, no runtime dependencies. RSpec is used only for tests.

## Requirements

- Ruby 3.3 or newer (developed on 3.3.8, see `.ruby-version`)
- Bundler (ships with Ruby), only needed to run the tests

## Install

```sh
bin/install
```

Checks the Ruby version and installs RSpec through Bundler. The application itself needs
nothing but Ruby, so `bin/run` works without this step.

## Run

Pass one or more basket files. Each file is one basket and prints its own receipt:

```sh
bin/run spec/fixtures/input_1.txt
bin/run spec/fixtures/input_1.txt spec/fixtures/input_2.txt spec/fixtures/input_3.txt
```

Or pipe a basket through STDIN:

```sh
printf "1 imported bottle of perfume at 47.50\n" | bin/run
```

Output for `spec/fixtures/input_3.txt`:

```
1 imported bottle of perfume: 32.19
1 bottle of perfume: 20.89
1 packet of headache pills: 9.75
3 imported boxes of chocolates: 35.55
Sales Taxes: 7.90
Total: 98.38
```

On invalid input, `bin/run` prints `Error: ...` naming the bad line or file to STDERR and
exits with status 1.

### Input format

One item per line: `<quantity> <product name> at <unit price>`, for example
`2 book at 12.49`. The quantity is a positive integer and the price has exactly two
decimals. Blank lines are ignored.

## Test

```sh
bundle exec rspec
```

- `spec/end_to_end_spec.rb` runs `bin/run` against the three inputs from the exercise
  (`spec/fixtures/input_*.txt`) and compares the output byte for byte with
  `spec/fixtures/output_*.txt`. It also covers STDIN input and the error paths. This is the
  main proof that the solution is complete.
- `spec/parser_spec.rb` covers malformed input, which the sample baskets never contain.
- `spec/calculator_spec.rb` covers rounding edge cases that are hard to read from a full
  receipt.

The project was built test-first: the end-to-end spec was written and seen failing before
any code existed.

## Design

```
input text ──> Parser ──> [Item] ──> Calculator ──> Result ──> Reporter ──> receipt text
                                         │
                                       Rules
```

| Object | Responsibility |
| --- | --- |
| `Parser` | Validates basket lines and turns them into `Item`s. |
| `Item` | Immutable value: quantity, name, unit price; knows if it is imported. |
| `Rules` | Tax policy: which rate applies to an item (basic 10% unless exempt, plus 5% import duty). |
| `Calculator` | Applies `Rules`, rounds tax, and returns lines with tax and totals. |
| `Reporter` | Formats a calculated result as receipt text. |
| `SalesTaxes.receipt_for` | Wires the three steps together. |

Why this shape:

- **One job per object.** Parsing, tax policy, arithmetic and formatting change for
  different reasons, so they live apart. A new output format (JSON, HTML) is a new reporter
  and touches nothing else.
- **Composition, not inheritance.** `Calculator` receives its rules
  (`Calculator.new(rules: Rules)`), so the tax policy can be swapped without subclassing.
- **Money is `BigDecimal`.** Floats cannot represent amounts like `0.05` exactly.
- **Thread-safe by construction.** `Item`, `Calculator::Line` and `Calculator::Result` are
  immutable `Data` objects. `Parser`, `Calculator` and `Reporter` hold no mutable state,
  and all constants are frozen (`# frozen_string_literal: true` everywhere). Any number of
  threads can build receipts at the same time without locks.

### Changing the tax policy

- New exempt product: add its keyword to `Rules::EXEMPT_PRODUCTS` (singular; a plural `s` is
  matched automatically).
- New rate or tax: change `Rules.rate_for`. Nothing else needs to change.

## Assumptions

1. **Tax is rounded per unit.** The rule says a *shelf price* `p` contains `np/100` rounded
   up to 0.05, and the shelf price is the price of one unit. So tax is computed on the unit
   price, rounded, then multiplied by the quantity. The exercise confirms this:
   `3 imported boxes of chocolates at 11.25` must cost `35.55`, which needs 0.60 tax per
   box (per-line rounding would give 35.45).
2. **Basic tax and import duty are added before rounding.** The combined rate is applied to
   the price and rounded once, matching the expected outputs (perfume at 27.99 → 4.20 tax).
3. **Exempt products are recognised by keyword.** The input has no category, so `Rules`
   matches `book`, `chocolate` and `pill` (books, food, medical) in the product name.
   Anything else is taxable. A real system would take the category from a product catalogue.
4. **"Imported" is a word in the name.** The name is printed exactly as given.
5. **The receipt price is the line total.** `2 book: 24.98` shows quantity × unit price,
   tax included, as in the expected output.
6. **Input is strict.** Malformed lines are rejected instead of guessed at, because a wrong
   guess would print a wrong receipt.

## Project layout

```
bin/install                 install test dependencies
bin/run                     command-line entry point
lib/sales_taxes.rb          wiring: parse -> calculate -> report
lib/sales_taxes/item.rb
lib/sales_taxes/parser.rb
lib/sales_taxes/rules.rb
lib/sales_taxes/calculator.rb
lib/sales_taxes/reporter.rb
spec/                       RSpec suite and the exercise fixtures
```
