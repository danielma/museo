require "thor"

module Museo
  class CLI < Thor
    desc "list [MATCHER]", "List snapshots that match MATCHER"
    def list(matcher = nil)
      directory = find_directory(matcher)

      if File.directory?(directory)
        puts "Directory: #{directory}\n\n"
        list_files(directory)
      else
        puts "No directory found: #{directory}"
      end
    end

    desc "clear [MATCHER]", "Clear snapshots that match MATCHER"
    def clear(matcher = nil)
      list(matcher)
      directory_to_clear = find_directory(matcher)

      return unless File.directory?(directory_to_clear)

      puts "Removing snapshots"
      FileUtils.remove_dir(directory_to_clear)
    end

    private

    def find_directory(matcher_or_pathname)
      return matcher_or_pathname if matcher_or_pathname.is_a?(Pathname)

      Museo.pathname(matcher_or_pathname)
    end

    def files(matcher)
      directory = find_directory(matcher)

      return [] unless directory

      Dir[directory.join("**", "*.snapshot")].map do |snapshot|
        Pathname.new(snapshot)
      end
    end

    def list_files(directory)
      files = files(directory)

      if files.any?
        files.each do |path|
          puts path.relative_path_from(directory)
        end
      else
        puts "No files"
      end
    end
  end
end
