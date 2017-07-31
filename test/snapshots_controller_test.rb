require "test_helper"
require "museo/cli"

class SnapshotsControllerResponseTest < ActionController::TestCase
  tests SnapshotsController

  include Museo::MinitestIntegration

  setup do
    Museo.clear!
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
    if Rails.gem_version < Gem::Version.new("5.0.0")
      get :index, one: "Dolores"
    else
      get :index, params: { one: "Dolores" }
    end
    @expected_response_includes = "Dolores"
  end

  teardown do
    assert_includes response.body, @expected_response_includes
    Museo.clear!
  end
end

class SnapshotsControllerSnapshotsTest < ActionController::TestCase
  tests SnapshotsController

  FAILURE_MESSAGE = "In this test class, snapshots should fail".freeze

  include Museo::MinitestIntegration

  setup do
    Museo.clear!
  end

  def assert_snapshot
    super
    flunk FAILURE_MESSAGE
  rescue Minitest::Assertion => e
    raise if e.message == FAILURE_MESSAGE
  end

  snapshot "should fail with different body" do
    get :index
    Museo::Snapshot::Minitest.new(self)
    if Rails.gem_version < Gem::Version.new("5.0.0")
      get :index, one: "Bernard"
    else
      get :index, params: { one: "Bernard" }
    end
  end

  teardown do
    Museo.clear!
  end
end

class SnapshotsControllerStubTest < ActionController::TestCase
  tests SnapshotsController

  include Museo::MinitestIntegration

  setup do
    Museo.configuration.stub(:render) do |options = {}, block = nil|
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
    Museo.configuration.clear_stubs!
    @expected_response_matches.each do |expected_match|
      assert_match expected_match, response.body
    end
    Museo.clear!
  end
end
