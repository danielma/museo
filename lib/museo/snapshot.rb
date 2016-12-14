require "fileutils"

module Museo
  class Snapshot
    mattr_accessor(:stubbed_methods) { {} }
    mattr_accessor(:formatter) { Museo::Formatter.new }

    def self.stub(name, value = nil)
      value = block_given? ? Proc.new : value

      stubbed_methods[name] = value
    end

    def self.list(matcher)
      folder_to_clear = folder(matcher)

      if File.directory?(folder_to_clear)
        puts "Clearing directory: #{folder_to_clear}\n\n"
        Dir["#{folder_to_clear}/**/*.snapshot"].each do |snapshot|
          puts snapshot.sub("#{folder_to_clear}/", "")
        end
        folder_to_clear
      else
        puts "No directory found: #{folder_to_clear}"
      end
    end

    def self.clear(matcher)
      folder_to_clear = list(matcher)

      FileUtils.remove_dir(folder_to_clear) if folder_to_clear
    end

    def self.clean_name(name)
      if name
        name.gsub("::", "/").gsub(/[^0-9a-z\/]+/i, "_")
      else
        ""
      end
    end

    def self.folder(class_name)
      Rails.root.join("test/snapshots", clean_name(class_name))
    end

    def self.sanitize_response(body)
      body.gsub(/:0x[a-fA-F0-9]{4,}/m, ":0xXXXXXX")
    end

    def initialize(test_case)
      @test_case = test_case

      update unless exists?
    end

    def body
      exists? ? File.read(path) : nil
    end

    private

    attr_reader :test_case

    delegate :clean_name, to: :class

    def exists?
      File.exist?(path)
    end

    def folder
      self.class.folder(test_case.class.to_s)
    end

    def file_name
      "#{clean_name(test_case.name)}.snapshot"
    end

    def path
      Rails.root.join(folder, file_name)
    end

    def update
      FileUtils.mkdir_p(folder)

      File.open(path, "wb") do |f|
        f.print self.class.sanitize_response(test_case.response.body.to_s)
      end

      puts "Updated snapshot for #{test_case.name.inspect}"
    end
  end
end
