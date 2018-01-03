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

  s.add_runtime_dependency("builder")
  s.add_runtime_dependency("nokogiri")
  s.add_runtime_dependency("activesupport", ["< 5.0"])
  s.add_runtime_dependency("i18n")
  s.add_runtime_dependency("httpclient")
  s.add_runtime_dependency("addressable")
  s.add_runtime_dependency("json")
end
