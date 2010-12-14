require "rubygems"

require 'bundler/setup'
Bundler::GemHelper.install_tasks

require "spec"
require "spec/rake/spectask"

desc "Run acceptance specs"
Spec::Rake::SpecTask.new("spec:acceptance") do |t|
  t.spec_files = ["spec/acceptance"]
end

desc "Run unit specs"
Spec::Rake::SpecTask.new("spec:unit") do |t|
  t.spec_files = ["spec/unit"]
end

desc "Run all specs"
task :spec => ["spec:unit", "spec:acceptance"]

task :default => ["spec"]

require "rake/rdoctask"
Rake::RDocTask.new do |rd|
  rd.rdoc_files.include("lib/**/*.rb", "README.rdoc")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package]
