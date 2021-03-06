require "fileutils"
require_relative "snapshot/rspec"
require_relative "snapshot/minitest"

module Museo
  class Snapshot
    class GenerationDisabledError < StandardError; end

    class << self
      def sanitize_response(body)
        body.gsub(/:0x[a-fA-F0-9]{4,}/, ":0xXXXXXX")
      end
    end

    def initialize(klass:, test_name:, response:)
      @class_name = klass.to_s
      @test_name = test_name
      @response = response

      generate unless exists?
    end

    def body
      exists? ? File.read(path) : nil
    end

    private

    def exists?
      File.exist?(path)
    end

    def folder
      Museo.pathname(@class_name)
    end

    def file_name
      "#{Museo.clean_name(@test_name)}.snapshot"
    end

    def path
      Museo.rails_root.join(folder, file_name)
    end

    def sanitized_response
      self.class.sanitize_response(@response.body.to_s)
    end

    def generate
      if Museo.configuration.generation_disabled
        fail GenerationDisabledError,
             "Can't generate snapshots in a CI environment. " \
             "Please generate snapshots locally first"
      end

      FileUtils.mkdir_p(folder)

      File.open(path, "wb") { |f| f.print sanitized_response }

      puts "Updated snapshot for #{file_name.inspect}"
    end
  end
end
