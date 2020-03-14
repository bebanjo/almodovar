require 'nokogiri'
begin
  require 'active_support/all'
rescue LoadError
  require 'active_support'
end

require 'almodovar/version' unless defined?(Almodovar::VERSION)
require 'almodovar/digest_auth'
require 'almodovar/http_client'
require 'almodovar/http_accessor'
require 'almodovar/resource'
require 'almodovar/resource_collection'
require 'almodovar/single_resource'
require 'almodovar/errors'
require 'almodovar/to_xml'

module Almodovar
  DEFAULT_SEND_TIMEOUT = 120
  DEFAULT_CONNECT_TIMEOUT = 30
  DEFAULT_RECEIVE_TIMEOUT = 120

  class << self

    # default_options allows to configure some settings on the underlying HTTP client used by Almodovar:
    #   - send_timeout: Request sending timeout in sec. Defaults to 120
    #   - connect_timeout: Connect timeout in sec. Defaults to 30
    #   - receive_timeout: Response receiving timeout in sec. Defaults to 120
    #   - user_agent: User-Agent header in HTTP request. defaults to Almodovar/#{Almodovar::VERSION}
    #   - force_basic_auth: flag for sending Authorization header w/o getting 401 first. Useful during tests
    #   - headers: is for providing default headers Hash that all HTTP
    #     requests should have, such as custom 'X-Request-Id' header in tracing.
    #     As Almodovar does not expose http API, this accept a proc which will be
    #     evaluated per request. You can override :headers with Almodovar::HTTPClient headers method
    #     or using Hash parameter in HTTP request methods but this is not accessible on default Almodovar usage.
    def default_options
      default = {
        send_timeout: DEFAULT_SEND_TIMEOUT,
        connect_timeout: DEFAULT_CONNECT_TIMEOUT,
        receive_timeout: DEFAULT_RECEIVE_TIMEOUT,
        user_agent: "Almodovar/#{Almodovar::VERSION}",
        force_basic_auth: false,
        headers: nil,
      }
      default.merge(@default_options || {})
    end

    def default_options=(options = {})
      @default_options = {
        send_timeout: options[:send_timeout],
        connect_timeout: options[:connect_timeout],
        receive_timeout: options[:receive_timeout],
        force_basic_auth: options[:force_basic_auth],
        headers: options[:headers]
      }
    end
  end
end
