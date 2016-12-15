require "museo/cli"

RSpec.describe SnapshotsController, type: :controller do
  include Museo::RspecIntegration

  describe "Responses" do
    before(:each) do
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

    snapshot "#index with one = Ford" do
      get :index, one: "Ford"
      @expected_response_includes = "Ford"
    end

    after(:each) do
      assert_includes response.body, @expected_response_includes
      Museo::CLI.new("clear")
    end
  end

  describe "Snapshots" do
    FAILURE_MESSAGE = "In this test group, snapshots should fail".freeze

    before(:each) do
      Museo::CLI.new("clear")
    end

    def expect_matching_snapshot(example)
      super
      fail FAILURE_MESSAGE
    rescue RSpec::Expectations::ExpectationNotMetError => e
      raise if e.message == FAILURE_MESSAGE
    end

    snapshot "should fail with different body" do |example|
      get :index
      Museo::Snapshot::Rspec.new(self, example.metadata)
      get :index, one: "Bernarnold"
    end

    after(:each) do
      Museo::CLI.new("clear")
    end
  end

  describe "Stubs" do
    before(:each) do
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

    after(:each) do
      Museo::Snapshot.clear_stubs!
      @expected_response_matches.each do |expected_match|
        expect(response.body).to match(expected_match)
      end
      Museo::CLI.new("clear")
    end
  end
end
