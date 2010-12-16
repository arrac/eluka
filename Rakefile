require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "eluka"
  gem.homepage = "http://github.com/arrac/eluka"
  gem.license = "MIT"
  gem.summary = %Q{one-line summary of your gem}
  gem.description = %Q{longer description of your gem}
  gem.email = "aditya.rachakonda@gmail.com"
  gem.authors = ["Aditya Rachakonda"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
  
  gem.add_dependency 'ferret'
  #gem.executables = ['install.rb']
  gem.extensions.push 'ext/extconf.rb'
end

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "eluka #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :install do
  puts "Install"
  `touch /tmp/12345install`
end

task :make_gem do
  puts "Make Gem"
  `touch /tmp/12345make_gem` 
end

task :build do
  puts "Build"
  `touch /tmp/12345build`
end
  