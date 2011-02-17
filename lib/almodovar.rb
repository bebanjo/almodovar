require File.dirname(__FILE__) + '/../vendor/resourceful-0.5.3-patched/lib/resourceful'
require 'nokogiri'
begin
  require 'active_support/all'
rescue LoadError
  require 'active_support'
end

require 'almodovar/to_xml'
require 'almodovar/digest_auth'
require 'almodovar/http_accessor'
require 'almodovar/resource'
require 'almodovar/resource_collection'
require 'almodovar/single_resource'