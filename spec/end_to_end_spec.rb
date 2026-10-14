# frozen_string_literal: true

require "open3"

RSpec.describe "bin/run" do
  def run(*, stdin: "")
    Open3.capture3(File.expand_path("../bin/run", __dir__), *, stdin_data: stdin)
  end

  Dir[File.join(__dir__, "fixtures/input_*.txt")].each do |input|
    it "prints the expected receipt for #{File.basename(input)}" do
      stdout, stderr, status = run(input)

      expect(stdout).to eq(File.read(input.sub("input_", "output_")))
      expect(stderr).to be_empty
      expect(status).to be_success
    end
  end

  it "reads the basket from STDIN when no file is given" do
    stdout, = run(stdin: "1 book at 12.49\n")

    expect(stdout).to eq("1 book: 12.49\nSales Taxes: 0.00\nTotal: 12.49\n")
  end

  it "reports malformed input and exits with failure" do
    _stdout, stderr, status = run(stdin: "1 book 12.49\n")

    expect(stderr).to eq(%(Error: Invalid line: "1 book 12.49"\n))
    expect(status.exitstatus).to eq(1)
  end

  it "reports a missing file and exits with failure" do
    _stdout, stderr, status = run("missing.txt")

    expect(stderr).to start_with("Error: No such file or directory")
    expect(status.exitstatus).to eq(1)
  end
end
