require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the resource_proxy plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the resource_proxy plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ResourceProxy'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "resource_proxy"
    gemspec.summary = "A utility wrapper for making ActiveResource more like ActiveRecord"
    gemspec.description = "An implementation of the Proxy design pattern for handling ActiveResource objects. Designed to ease the burden of working with ActiveResource objects in forms."
    gemspec.email = "nate@natemiller.org"
    gemspec.homepage = "http://github.com/nate63179/resource_proxy"
    gemspec.authors = ["Nate Miller"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end