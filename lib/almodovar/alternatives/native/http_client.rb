require 'patron'

module Almodovar
  module Alternatives
    module Native

      class HttpClient

        attr_reader :session
        delegate :timeout=,
                 :connect_timeout=,
                 :username=,
                 :password=,
                 :auth_type=,
                 :get, :post, :put, :delete,
                 :to => :session

        def agent_name=(value)
          @session.headers['User-Agent'] = value
        end

        def initialize
          @session = Patron::Session.new
        end
      end

    end
  end
end