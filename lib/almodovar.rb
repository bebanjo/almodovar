require File.dirname(__FILE__) + '/../vendor/resourceful-0.5.3-patched/lib/resourceful'
require 'nokogiri'
require 'active_support'
require 'to_xml'
require 'uri'

module Almodovar
  
  class DigestAuth < Resourceful::DigestAuthenticator
  end
  
  module HttpAccessor
    
    def xml
      @xml ||= begin
        response = http.resource(url_with_params).get
        Nokogiri.parse(response.body).root
      end
    end
    
    private
    
    def url_with_params
      @options[:expand] = @options[:expand].join(",") if @options[:expand].is_a?(Array)
      params = @options.map { |k, v| "#{k}=#{v}" }.join("&")
      params = "?#{params}" unless params.empty?
      @url + params
    end
    
    def http
      Resourceful::HttpAccessor.new(:authenticator => @auth)
    end
    
  end
  
  class SingleResource
    
    include HttpAccessor
    
    undef id
    
    def initialize(url, auth, xml = nil, options = {})
      @url = url
      @auth = auth
      @xml = xml
      @options = options
    end
    
    def update(attrs = {})
      response = http.resource(@url).put(attrs.to_xml(:root => object_type), :content_type => "application/xml")
      @xml = Nokogiri.parse(response.body).root
    end
    
    def delete
      http.resource(@url).delete
    end
    
    def url
      @url ||= xml.at_xpath("./link[@rel='self']").try(:[], "href")
    end
    
    delegate :to_xml, :to => :xml
    alias_method :inspect, :to_xml
    
    private
    
    def object_type
      @object_type ||= URI.parse(@url).path.split("/")[-2].singularize
    end
    
    def method_missing(meth, *args, &blk)
      attribute = xml.at_xpath("./*[name()='#{meth}' or name()='#{attribute_name(meth)}']")
      return node_text(attribute) if attribute
      
      link = xml.at_xpath("./link[@rel='#{meth}' or @rel='#{attribute_name(meth)}']")
      return Resource.new(link["href"], @auth, link.at_xpath("./*"), *args) if link
      
      super
    end
    
    def node_text(node)
      case node['type']
      when "integer": node.text.to_i
      when "datetime": Time.parse(node.text)
      else
        node.text
      end
    end
    
    def attribute_name(attribute)
      attribute.to_s.gsub('_', '-')
    end
    
  end
  
  class ResourceCollection
    
    include HttpAccessor
    
    delegate :inspect, :to => :resources
    
    def initialize(url, auth, xml = nil, options = {})
      @url = url
      @auth = auth
      @xml = xml if options.empty?
      @options = options
    end
    
    def create(attrs = {})
      response = http.resource(@url).post(attrs.to_xml(:root => object_type, :convert_links => true), :content_type => "application/xml")
      Resource.new(nil, @auth, Nokogiri.parse(response.body).root)
    end
    
    private
    
    def object_type
      @object_type ||= URI.parse(@url).path.split("/").last.singularize
    end
    
    def resources
      @resources ||= xml.xpath("./*").map { |subnode| Resource.new(subnode.at_xpath("./link[@rel='self']").try(:[], "href"), @auth, subnode, @options) }
    end
    
    def method_missing(meth, *args, &blk)
      resources.send(meth, *args, &blk)
    end
  end
  
  class Resource
    
    include HttpAccessor
    
    undef id
    
    delegate :inspect, :to => :get!
    
    def initialize(url, auth, xml = nil, options = {})
      @url = url
      @auth = auth
      @xml = xml
      @options = options
    end
    
    def method_missing(meth, *args, &blk)
      @resource_object ||= resource_class(meth).new(@url, @auth, @xml, @options)
      @resource_object.send(meth, *args, &blk)
    end
    
    def resource_class(meth)
      @resource_class ||= if [:create, :[], :first, :last, :size].include?(meth)
        ResourceCollection
      else
        SingleResource
      end
    end
    
    def get!
      klass = xml['type'] == 'array' ? ResourceCollection : SingleResource
      @resource_object = klass.new(@url, @auth, @xml, @options)
    end
        
  end
  
  def self.Resource(url, auth, params = {})
    Resource.new(url, auth, nil, params)
  end
  
end