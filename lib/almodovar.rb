require 'nokogiri'
begin
  require 'active_support/all'
rescue LoadError
  require 'active_support'
end

require 'almodovar/version' unless defined?(Almodovar::VERSION)
require 'almodovar/alternatives/alternatives'
require 'almodovar/digest_auth'
require 'almodovar/http_accessor'
require 'almodovar/resource'
require 'almodovar/resource_collection'
require 'almodovar/single_resource'
require 'almodovar/errors'
require 'almodovar/to_xml'
require 'almodovar/resource_presenter'
require 'almodovar/resource_presenter/collection'
require 'almodovar/resource_presenter/link'


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