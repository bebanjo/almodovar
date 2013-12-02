require 'nokogiri'
begin
  require 'active_support/all'
rescue LoadError
  require 'active_support'
end

require 'almodovar/version' unless defined?(Almodovar::VERSION)
require 'almodovar/alternatives'
require 'almodovar/digest_auth'
require 'almodovar/http_accessor'
require 'almodovar/resource'
require 'almodovar/resource_collection'
require 'almodovar/single_resource'
require 'almodovar/errors'
require 'almodovar/to_xml'

module Almodovar

  class << self
    def default_options
      @default_options ||= {
        :timeout => 120,
        :connect_timeout => 30,
        :user_agent => "Almodovar/#{Almodovar::VERSION}"
      }
    end
  end
end