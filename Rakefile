require 'rubygems'
require 'rake'
require 'bundler'
Bundler.setup
Bundler.require

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "resource_defaults"
    gem.summary = %Q{Allows setting defaults for resources in Rails routing}
    gem.description = %Q{If you have resources accessible from multiple routes, it's useful to be able to set default actions. This gem makes that possible.}
    gem.email = "stalkingtiger@gmail.com"
    gem.homepage = "http://github.com/aughr/resource_defaults"
    gem.authors = ["Andrew Bloomgarden"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "resource_defaults #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
