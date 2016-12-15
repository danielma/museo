require "test_helper"
require "museo/cli"

class MuseoTest < ActiveSupport::TestCase
  class SnapshotsControllerResponseTest < ActionController::TestCase
    tests SnapshotsController

    include Museo::Minitest

    setup do
      Museo::CLI.new("clear")
      @expected_response_includes = nil
    end

    snapshot "uses snapshot layout" do
      get :index
      @expected_response_includes = "<!-- content_for page_title -->"
    end

    snapshot "#index with no params" do
      get :index
      @expected_response_includes = "Snapshot named No name"
    end

    snapshot "#index with one = Dolores" do
      get :index, one: "Dolores"
      @expected_response_includes = "Dolores"
    end

    teardown do
      assert_includes response.body, @expected_response_includes
      Museo::CLI.new("clear")
    end
  end

  class SnapshotsControllerSnapshotsTest < ActionController::TestCase
    tests SnapshotsController

    FAILURE_MESSAGE = "In this test class, snapshots should fail".freeze

    include Museo::Minitest

    setup do
      Museo::CLI.new("clear")
    end

    def assert_snapshot
      super
      flunk FAILURE_MESSAGE
    rescue Minitest::Assertion => e
      raise if e.message == FAILURE_MESSAGE
    end

    snapshot "should fail with different body" do
      get :index
      Museo::Snapshot.new(self)
      get :index, one: "Bernard"
    end

    teardown do
      Museo::CLI.new("clear")
    end
  end

  class SnapshotsControllerStubTest < ActionController::TestCase
    tests SnapshotsController

    include Museo::Minitest

    setup do
      Museo::Snapshot.stub(:render) do |options = {}, block = nil|
        options[:content] = capture(&block) if block
        options
      end
      @expected_response_matches = []
    end

    snapshot "stub should change response output" do
      get :index
      @expected_response_matches = [/stubbed method call: render/i, "Snapshot:0x"]
    end

    teardown do
      Museo::Snapshot.clear_stubs!
      @expected_response_matches.each do |expected_match|
        assert_match expected_match, response.body
      end
      Museo::CLI.new("clear")
    end
  end
end
