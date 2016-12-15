require "rails"
require "museo/version"
require "museo/formatter"
require "museo/snapshot"
require "museo/test_integration"
require "museo/minitest_integration"
require "museo/rspec_integration"
require "museo/engine"

module Museo
  def self.rails_root
    @rails_root ||= Rails::Application.find_root(Dir.pwd)
  end
end
