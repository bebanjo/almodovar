require File.expand_path('../lib/almodovar/version', __FILE__)

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = "almodovar"
  s.version           = Almodovar::VERSION
  s.summary           = "BeBanjo API client"
  s.author            = "BeBanjo S.L."
  s.email             = "ballsbreaking@bebanjo.com"
  s.homepage          = "http://wiki.github.com/bebanjo/almodovar/"
  s.license           = "MIT"

  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)

  s.files             = %w(README.rdoc) + Dir.glob("{lib/**/*}")
  s.require_paths     = ["lib"]

  s.add_runtime_dependency("builder",       [">= 2.1",   "< 3.3"])
  s.add_runtime_dependency("nokogiri",      [">= 1.5.4", "< 1.9"])
  s.add_runtime_dependency("activesupport", [">= 3.0",   "< 5.0"])
  s.add_runtime_dependency("i18n",          [">= 0.2",   "< 0.10"])
  s.add_runtime_dependency("httpclient",    [">= 2.5.2", "< 2.9"])
  s.add_runtime_dependency("addressable",   [">= 2.3.6", "< 2.6"])
  s.add_runtime_dependency("json",          [">= 1.8.2", "< 2.2"])
end
