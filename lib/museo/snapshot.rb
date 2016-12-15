require "fileutils"

module Museo
  class Snapshot
    extend Forwardable

    @stubbed_methods = {}
    @formatter = Museo::Formatter.new

    class << self
      attr_reader :stubbed_methods
      attr_accessor :formatter

      def stub(name, value = nil)
        value = block_given? ? Proc.new : value

        @stubbed_methods[name] = value
      end

      def clear_stubs!
        @stubbed_methods = {}
      end

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

    def initialize(test_case)
      @test_case = test_case

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
      self.class.folder(@test_case.class.to_s)
    end

    def file_name
      "#{clean_name(@test_case.name)}.snapshot"
    end

    def path
      Museo.rails_root.join(folder, file_name)
    end

    def update
      FileUtils.mkdir_p(folder)

      File.open(path, "wb") do |f|
        f.print self.class.sanitize_response(@test_case.response.body.to_s)
      end

      puts "Updated snapshot for #{file_name.inspect}"
    end
  end
end
