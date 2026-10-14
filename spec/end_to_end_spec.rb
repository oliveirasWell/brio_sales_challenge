# frozen_string_literal: true

require "open3"
require "rbconfig"

RSpec.describe "bin/run" do
  let(:run_script) { File.expand_path("../bin/run", __dir__) }

  def fixture(name) = File.expand_path("fixtures/#{name}", __dir__)

  # bin/run uses only the standard library, so run it outside the bundle like a user would.
  def run(*args, **opts) = Bundler.with_unbundled_env { Open3.capture3(RbConfig.ruby, run_script, *args, **opts) }

  (1..3).each do |n|
    it "prints the expected receipt for input #{n}" do
      stdout, stderr, status = run(fixture("input_#{n}.txt"))

      expect(stderr).to be_empty
      expect(status).to be_success
      expect(stdout).to eq(File.read(fixture("output_#{n}.txt")))
    end
  end

  it "reads the basket from STDIN when no file is given" do
    stdout, _stderr, status = run(stdin_data: File.read(fixture("input_1.txt")))

    expect(status).to be_success
    expect(stdout).to eq(File.read(fixture("output_1.txt")))
  end
end
