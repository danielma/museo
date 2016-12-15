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
      folder_to_clear = Snapshot.folder(matcher)

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

    def clear(matcher)
      folder_to_clear = list(matcher)

      FileUtils.remove_dir(folder_to_clear) if folder_to_clear
    end
  end
end
