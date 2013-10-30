source "https://rubygems.org"

gemspec

gem 'rake'
gem 'rspec'
gem 'webmock'
gem 'lorax'
gem 'rdoc'
gem 'rack'

gem 'activesupport', '~> 3.1.0'

gem 'ruby-debug',   :platform => :mri_18
gem 'ruby-debug19', :platform => :mri_19, :require => 'ruby-debug'
gem 'patron',       :platforms => [:mri_18, :mri_19]
gem 'pygments.rb',  :platforms => [:mri_18, :mri_19]
gem 'github-markdown',  :platforms => [:mri_18, :mri_19]
gem 'coderay',      :platform => :jruby
gem 'httpclient',   :platform => :jruby
gem 'kramdown',     :platform => :jruby
gem 'pry', :require => "pry"

group :test do
  gem 'thin',       :platforms => [:mri_18, :mri_19]
  gem 'jruby-rack', :platform  => :jruby
end
