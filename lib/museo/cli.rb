module Museo
  class CLI
    def initialize(command, *args)
      puts "hi!"
    end
  end
end

# require_relative "../../test/support/snapshot_testing"

# namespace :snapshots do
#   desc "Clear snapshots for a certain class"
#   task :clear, [:class] => :environment do |_, args|
#     ViewSnapshot.clear(args[:class])
#   end

#   desc "List snapshots"
#   task :list, [:class] => :environment do |_, args|
#     ViewSnapshot.list(args[:class])
#   end
# end
