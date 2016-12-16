module Museo
  class CLI
    def initialize(command = nil, *argv)
      case command.to_s.strip.downcase
      when "clear"
        clear(argv.first)
      when "list"
        list(argv.first)
      when ""
        puts "Please add a command"
      else
        puts "Don't know how to do command: #{command}"
      end
    end

    def list(matcher)
      directory = find_directory(matcher)

      if File.directory?(directory)
        puts "Directory: #{directory}\n\n"
        list_files(directory)
      else
        puts "No directory found: #{directory}"
      end
    end

    def clear(matcher)
      list(matcher)
      directory_to_clear = find_directory(matcher)

      return unless File.directory?(directory_to_clear)

      puts "Removing snapshots"
      FileUtils.remove_dir(directory_to_clear)
    end

    def update(matcher)
      list(matcher)

      # Minitest::Test.class_eval do
      #   def test
      #     puts "noop"
      #   end
      # end

      # Dir.chdir(Museo.rails_root) do
        
      # end
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
