Gem::Specification.new do |s|
  s.name              = "almodovar"
  s.version           = "0.5.6"
  s.summary           = "BeBanjo API client"
  s.author            = "BeBanjo S.L."
  s.email             = "ballsbreaking@bebanjo.com"
  s.homepage          = "http://wiki.github.com/bebanjo/almodovar/"
  
  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)
  
  s.files             = %w(README.rdoc) + Dir.glob("{lib/**/*}")
  s.require_paths     = ["lib"]
  
  s.add_dependency("patron")
  s.add_dependency("builder")
  s.add_dependency("nokogiri")
  s.add_dependency("activesupport")
  s.add_dependency("i18n")
  s.add_dependency("yajl-ruby")
end