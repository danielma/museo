require "rubygems"

begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

require "rdoc/task"

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "Museo"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README.rdoc")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

Bundler::GemHelper.install_tasks

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
  t.warning = false
end

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.pattern = Dir.glob("spec/**/*_spec.rb")
end

task default: %i(test spec)
