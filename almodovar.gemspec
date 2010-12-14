Gem::Specification.new do |s|
  s.name              = "almodovar"
  s.version           = "0.5.5"
  s.summary           = "BeBanjo API client"
  s.author            = "BeBanjo S.L."
  s.email             = "ballsbreaking@bebanjo.com"
  s.homepage          = "http://wiki.github.com/bebanjo/almodovar/"
  
  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)
  
  s.files             = %w() + Dir.glob("{vendor/**/*,lib/**/*}")
  s.require_paths     = ["lib"]
  
  s.add_dependency("resourceful", "= 0.5.3")
  s.add_dependency("nokogiri")
  s.add_dependency("activesupport", "~> 2.3.0")
  
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec", "~> 1.3.0")
  s.add_development_dependency("steak")
  s.add_development_dependency("webmock", "~> 1.3.0")
end