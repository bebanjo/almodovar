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
    def default_options
      default = {
        send_timeout: DEFAULT_SEND_TIMEOUT,
        connect_timeout: DEFAULT_CONNECT_TIMEOUT,
        receive_timeout: DEFAULT_RECEIVE_TIMEOUT,
        user_agent: "Almodovar/#{Almodovar::VERSION}",
        force_basic_auth: false
      }
      default.merge(@default_options || {})
    end

    def default_options=(options = {})
      @default_options = {
        send_timeout: options[:send_timeout],
        connect_timeout: options[:connect_timeout],
        receive_timeout: options[:receive_timeout],
        force_basic_auth: options[:force_basic_auth]
      }
    end
  end
end
