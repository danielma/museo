require "test_helper"
require "museo/cli"

module Museo
  class SnapshotTest < ActiveSupport::TestCase
    test ".sanitize_response" do
      original = Object.new.to_s

      assert_equal "#<Object:0xXXXXXX>", described_class.sanitize_response(original)
    end

    test "initialize updates the snapshot" do
      refute File.directory?(Museo.pathname("TestClass"))

      described_class.new(klass: "TestClass", test_name: "test_snapshot", response: OpenStruct.new)

      assert File.directory?(Museo.pathname("TestClass"))
    end

    test "raises an error if generation is disabled" do
      with_generation_disabled do
        assert_raises described_class::GenerationDisabledError do
          described_class.new(
            klass: "TestClass",
            test_name: "test_snapshot",
            response: OpenStruct.new,
          )
        end
      end
    end

    def teardown
      Museo.clear!
    end

    def with_generation_disabled
      original_disabled = Museo.configuration.generation_disabled
      Museo.configuration.generation_disabled = true
      yield
    ensure
      Museo.configuration.generation_disabled = original_disabled
    end
  end
end
