require "rails"
require "museo/version"
require "museo/formatter"
require "museo/snapshot"
require "museo/test_integration"
require "museo/minitest_integration"
require "museo/rspec_integration"
require "museo/engine"

module Museo
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def rails_root
      @rails_root ||= Rails::Application.find_root(Dir.pwd)
    end

    def clean_name(name)
      if name
        name.gsub("::", "/").gsub(/[^0-9a-z\/]+/i, "_")
      else
        ""
      end
    end

    def pathname(class_name = "")
      test_directory = Museo.configuration.rspec ? "spec" : "test"

      Museo.rails_root.join(test_directory, "snapshots", clean_name(class_name))
    end
  end

  class Configuration
    attr_accessor :formatter
    attr_accessor :rspec

    def initialize
      @formatter = Museo::Formatter.new
      @rspec = false
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
