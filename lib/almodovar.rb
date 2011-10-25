require 'patron'
require 'nokogiri'
begin
  require 'active_support/all'
rescue LoadError
  require 'active_support'
end

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
