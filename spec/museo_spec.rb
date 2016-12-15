RSpec.describe Museo do
  it "uses spec directory for rspec configuration" do
    described_class.configure do |config|
      config.rspec = true
    end

    expect(described_class.pathname("hello").to_s).to include("spec/snapshots/hello")
  end
end
