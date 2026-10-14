# frozen_string_literal: true

require "open3"
require "rbconfig"

RSpec.describe "bin/run" do
  inputs = Dir[File.join(__dir__, "fixtures/input_*.txt")].sort

  def expected_output(input) = File.read(input.sub("input_", "output_"))

  def run(*args, **opts)
    script = File.expand_path("../bin/run", __dir__)
    stdout, stderr, status = Bundler.with_unbundled_env { Open3.capture3(RbConfig.ruby, script, *args, **opts) }
    [stdout, stderr, status.exitstatus]
  end

  inputs.each do |input|
    it "prints the expected receipt for #{File.basename(input)}" do
      expect(run(input)).to eq([expected_output(input), "", 0])
    end
  end

  it "prints one receipt per basket, separated by a blank line" do
    expect(run(*inputs)).to eq([inputs.map { expected_output(_1) }.join("\n"), "", 0])
  end

  it "reads the basket from STDIN when no file is given" do
    expect(run(stdin_data: File.read(inputs.first))).to eq([expected_output(inputs.first), "", 0])
  end

  it "reports malformed input and exits with failure" do
    expect(run(stdin_data: "1 book 12.49\n")).to eq(["", %(Error: Invalid line: "1 book 12.49"\n), 1])
  end

  it "reports a missing file and exits with failure" do
    expect(run("missing.txt")).to match(["", start_with("Error: No such file or directory"), 1])
  end
end
