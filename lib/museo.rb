require "rails"
require "museo/version"
require "museo/formatter"
require "museo/snapshot"
require "museo/minitest"
require "museo/rspec"
require "museo/engine"

module Museo
  def self.rails_root
    @rails_root ||= Rails::Application.find_root(Dir.pwd)
  end
end
