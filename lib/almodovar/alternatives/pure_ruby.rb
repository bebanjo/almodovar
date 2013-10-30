$: << File.join(File.dirname(__FILE__), 'pure_ruby')

require 'jruby-rack'
require 'http_client.rb'
require 'json_parser.rb'
require 'json_encoder.rb'
require 'html_serializer.rb'

module Almodovar
  module Alternatives

    JSONEncoder = Almodovar::Alternatives::PureRuby::JSONEncoder
    JSONParser = Almodovar::Alternatives::PureRuby::JSONParser
    HtmlSerialzer = Almodovar::Alternatives::PureRuby::HtmlSerializer
    HttpClient = Almodovar::Alternatives::PureRuby::HttpClient
    require 'pry'
    binding.pry
    RackHandler = ::Rack::Handler::Servlet

  end
end