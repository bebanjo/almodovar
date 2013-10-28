source "https://rubygems.org"

gemspec

gem 'rake'
gem 'rspec'
gem 'webmock'
gem 'lorax'
gem 'rdoc'

gem 'activesupport', '~> 3.1.0'
gem 'pygments.rb'
gem 'github-markdown'

gem 'ruby-debug',   :platform => :mri_18
gem 'ruby-debug19', :platform => :mri_19, :require => 'ruby-debug'
gem 'patron',       :platforms => [:mri_18, :mri_19]
gem 'httpclient',   :platforms => [:jruby]

group :test do
  gem 'rack',       :platforms => [:mri_18, :mri_19]
  gem 'thin',       :platforms => [:mri_18, :mri_19]
  gem 'jruby-rack', :platform  => :jruby
end
