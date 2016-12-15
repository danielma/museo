require "fileutils"
require_relative "snapshot/rspec"
require_relative "snapshot/minitest"

module Museo
  class Snapshot
    extend Forwardable

    class << self
      def clean_name(name)
        if name
          name.gsub("::", "/").gsub(/[^0-9a-z\/]+/i, "_")
        else
          ""
        end
      end

      def folder(class_name)
        Museo.rails_root.join("test/snapshots", clean_name(class_name))
      end

      def sanitize_response(body)
        body.gsub(/:0x[a-fA-F0-9]{4,}/, ":0xXXXXXX")
      end
    end

    def initialize(klass:, test_name:, response:)
      @class_name = klass.to_s
      @test_name = test_name
      @response = response

      update unless exists?
    end

    def body
      exists? ? File.read(path) : nil
    end

    private

    delegate([:clean_name] => self)

    def exists?
      File.exist?(path)
    end

    def folder
      self.class.folder(@class_name)
    end

    def file_name
      "#{clean_name(@test_name)}.snapshot"
    end

    def path
      Museo.rails_root.join(folder, file_name)
    end

    def update
      FileUtils.mkdir_p(folder)

      File.open(path, "wb") do |f|
        f.print self.class.sanitize_response(@response.body.to_s)
      end

      puts "Updated snapshot for #{file_name.inspect}"
    end
  end
end
