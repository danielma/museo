require "fileutils"
require_relative "snapshot/rspec"
require_relative "snapshot/minitest"

module Museo
  class Snapshot
    class << self
      def sanitize_response(body)
        body.gsub(/:0x[a-fA-F0-9]{4,}/, ":0xXXXXXX")
      end
    end

    def initialize(klass:, test_name:, response:)
      @class_name = klass.to_s
      @test_name = test_name
      @response = response
    end

    def body
      exists? ? File.read(path) : fail("No snapshot found")
    end

    def update
      FileUtils.mkdir_p(folder)

      File.open(path, "wb") do |f|
        f.print self.class.sanitize_response(@response.body.to_s)
      end

      puts "Updated snapshot for #{file_name.inspect}"
    end

    private

    def exists?
      File.exist?(path)
    end

    def folder
      Museo.pathname(@class_name)
    end

    def file_name
      "#{Museo.clean_name(@test_name).join}.snapshot"
    end

    def path
      Museo.rails_root.join(folder, file_name)
    end
  end
end
