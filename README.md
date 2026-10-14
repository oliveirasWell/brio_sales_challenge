# Sales Taxes

Prints shopping receipts with sales taxes, as described in the
[exercise](https://gist.github.com/safplatform/792314da6b54346594432f30d5868f36).

## Setup

Requires Ruby 3.4+ (`.ruby-version` uses 4.0.7).

```sh
bin/install
```

## Run

```sh
bin/run spec/fixtures/input_1.txt
bin/run < spec/fixtures/input_2.txt
```

Each line is `<quantity> <product> at <price>`. Invalid input prints an error and exits
with status 1.

## Test

```sh
bundle exec rspec
bundle exec rubocop
```

The end-to-end spec checks the three exercise inputs against their expected receipts.

## Docker

```sh
docker build -t sales-taxes .
docker run --rm sales-taxes                                      # runs the specs
docker run --rm sales-taxes bin/run spec/fixtures/input_3.txt
```
