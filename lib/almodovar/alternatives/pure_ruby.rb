$: << File.join(File.dirname(__FILE__), 'pure_ruby')

require 'http_client.rb'
require 'json_parser.rb'
require 'json_encoder.rb'

module Almodovar
  module Alternatives

    JSONEncoder = Almodovar::Alternatives::PureRuby::JSONEncoder
    JSONParser = Almodovar::Alternatives::PureRuby::JSONParser
    HttpClient = Almodovar::Alternatives::PureRuby::HttpClient

  end
end