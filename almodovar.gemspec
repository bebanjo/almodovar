Gem::Specification.new do |s|
  s.name              = "almodovar"
  s.version           = "0.5.6"
  s.summary           = "BeBanjo API client"
  s.author            = "BeBanjo S.L."
  s.email             = "ballsbreaking@bebanjo.com"
  s.homepage          = "http://wiki.github.com/bebanjo/almodovar/"
  
  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)
  
  s.files             = %w() + Dir.glob("{vendor/**/*,lib/**/*}")
  s.require_paths     = ["lib"]
  
  s.add_dependency("resourceful", "= 0.5.3")
  s.add_dependency("nokogiri")
  s.add_dependency("activesupport", "~> 2.3.0")
  s.add_dependency("yajl-ruby")
end