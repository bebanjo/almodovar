$: << File.join(File.dirname(__FILE__))

module Almodovar

  def self.alternatives
    @alternatives ||= if RUBY_PLATFORM =~ /java/
                        require 'jruby-rack'
                        require 'httpclient_session.rb'
                        require 'json_parser.rb'
                        require 'json_encoder.rb'
                        JRubyAlternatives.new
                      else
                        require 'yajl'
                        require 'patron_session.rb'
                        require 'thin'
                        MRIAlternatives.new
                      end
  end

  class JRubyAlternatives

    def json_encoder
      Almodovar::Alternatives::JSONEncoder
    end

    def json_parser
      Almodovar::Alternatives::JSONParser
    end

    def http_session
      Almodovar::Alternatives::HttpClientSession
    end

    def rack_handler
      Rack::Handler::Servlet
    end
  end

  class MRIAlternatives

    def json_encoder
      Yajl::Encoder
    end

    def json_parser
      Yajl::Parser
    end

    def http_session
      Almodovar::Alternatives::PatronSession
    end

    def rack_handler
      Rack::Handler::Thin
    end
  end
end