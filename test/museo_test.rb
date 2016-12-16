require "test_helper"

class MuseoTest < ActiveSupport::TestCase
  test ".configure add configuration" do
    with_modified_configuration do
      formatter = Object.new

      described_class.configure do |config|
        config.stub(:render, nil)
        config.formatter = formatter
      end

      assert_equal 1, described_class.configuration.stubbed_methods.length
      assert_equal formatter, described_class.configuration.formatter
    end
  end

  test "clear_stubs!" do
    with_modified_configuration do
      described_class.configure do |config|
        config.stub(:render, nil)
      end

      assert_equal 1, described_class.configuration.stubbed_methods.length

      described_class.configuration.clear_stubs!

      assert_empty described_class.configuration.stubbed_methods
    end
  end

  test "uses rspec directory if spec directory is found" do
    with_modified_configuration do
      assert_includes described_class.pathname("hello").to_s, "spec/snapshots/hello"

      described_class.configuration.rspec = false

      assert_includes described_class.pathname("hello").to_s, "test/snapshots/hello"
    end
  end

  def with_modified_configuration
    old_configuration = Museo.configuration
    Museo.clear_configuration!
    yield
  ensure
    Museo.instance_variable_set(:@configuration, old_configuration)
  end
end
