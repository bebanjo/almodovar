require "rubygems"

require 'bundler/setup'
include Rake::DSL
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc 'Default: run specs.'
task default: :spec

desc "Run all specs"
RSpec::Core::RakeTask.new("spec") do |t|
  t.pattern = "spec/**/*_spec.rb"
end

desc "Run unit specs"
RSpec::Core::RakeTask.new("spec:unit") do |t|
  t.pattern = "spec/unit/**/*_spec.rb"
end

desc "Run acceptance specs"
RSpec::Core::RakeTask.new("spec:acceptance") do |t|
  t.pattern = "spec/acceptance/**/*_spec.rb"
end

require "rdoc/task"
Rake::RDocTask.new do |rd|
  rd.rdoc_files.include("lib/**/*.rb", "README.rdoc")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task clean: [:clobber_rdoc, :clobber_package]
