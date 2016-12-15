require "rails"
require "museo/version"
require "museo/formatter"
require "museo/snapshot"
require "museo/test_integration"
require "museo/minitest_integration"
require "museo/rspec_integration"
require "museo/engine"

module Museo
  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.rails_root
    @rails_root ||= Rails::Application.find_root(Dir.pwd)
  end

  class Configuration
    attr_accessor :formatter

    def initialize
      @formatter = Museo::Formatter.new
    end

    def stubbed_methods
      @stubbed_methods ||= {}
    end

    def stub(name, value = nil)
      value = block_given? ? Proc.new : value

      stubbed_methods[name] = value
    end

    def clear_stubs!
      @stubbed_methods = {}
    end
  end
end
