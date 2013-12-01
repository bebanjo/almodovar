$: << File.join(File.dirname(__FILE__), 'native')

require 'yajl'
require 'http_client.rb'

module Almodovar
  module Alternatives

    JSONEncoder = Yajl::Encoder
    JSONParser = Yajl::Parser
    HttpClient = Almodovar::Alternatives::Native::HttpClient

  end
end