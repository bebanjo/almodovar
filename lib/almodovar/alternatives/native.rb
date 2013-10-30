$: << File.join(File.dirname(__FILE__), 'native')

require 'yajl'
require 'http_client.rb'
require 'thin'
require 'html_serializer.rb'

module Almodovar
  module Alternatives

    JSONEncoder = Yajl::Encoder
    JSONParser = Yajl::Parser
    HtmlSerialzer = Almodovar::Alternatives::Native::HtmlSerializer
    HttpClient = Almodovar::Alternatives::Native::HttpClient
    RackHandler = Rack::Handler::Thin

  end
end