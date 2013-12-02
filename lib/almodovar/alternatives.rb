$: << File.join(File.dirname(__FILE__), 'alternatives')

if RUBY_PLATFORM =~ /java/
  require 'pure_ruby.rb'
else
  require 'native.rb'
end