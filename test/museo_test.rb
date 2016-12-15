require "test_helper"

class MuseoTest < ActiveSupport::TestCase
  test ".configure add configuration" do
    formatter = Object.new

    described_class.configure do |config|
      config.stub(:render, nil)
      config.formatter = formatter
    end

    assert_equal 1, described_class.configuration.stubbed_methods.length
    assert_equal formatter, described_class.configuration.formatter
  end

  test "clear_stubs!" do
    described_class.configure do |config|
      config.stub(:render, nil)
    end

    assert_equal 1, described_class.configuration.stubbed_methods.length

    described_class.configuration.clear_stubs!

    assert_empty described_class.configuration.stubbed_methods
  end

  test "uses minitest test directory by default" do
    assert_includes described_class.pathname("hello").to_s, "test/snapshots/hello"
  end
end
