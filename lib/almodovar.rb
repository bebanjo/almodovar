require File.dirname(__FILE__) + '/../vendor/resourceful-0.5.3-patched/lib/resourceful'
require 'nokogiri'
require 'active_support'

module Almodovar
  
  class DigestAuth < Resourceful::DigestAuthenticator
  end
  
  module HttpAccessor
    def http(auth = nil)
      Resourceful::HttpAccessor.new(:authenticator => auth || @auth)
    end    
  end
  
  class Resource
    
    include HttpAccessor
    
    def initialize(auth, xml)
      @auth = auth
      @xml = xml
      @object_type = xml.name
    end
    
    delegate :to_xml, :to => :@xml
    alias_method :inspect, :to_xml
    
    def href
      @xml.at_xpath("./link[@rel='self']")["href"]
    end
    
    def ==(other)
      to_xml == other.to_xml
    end
    
    def update(attrs = {})
      response = http.resource(href).put(attrs.to_xml(:root => @object_type), :content_type => "application/xml")
      @xml = Nokogiri.parse(response.body).root
    end
    
    def delete
      http.resource(href).delete
    end
    
    private
    
    undef id
    
    def method_missing(meth, *args, &blk)
      attribute = @xml.at_xpath("./*[name()='#{meth}' or name()='#{attribute_name(meth)}']")
      return node_text(attribute) if attribute
      
      link = @xml.at_xpath("./link[@rel='#{meth}' or @rel='#{attribute_name(meth)}']")
      return get_linked_resource(link, *args) if link
      
      super
    end
    
    def get_linked_resource(link, options = {})
      expansion = link.at_xpath("./*")
      options.empty? && expansion ? Almodovar.instantiate(expansion, @auth, link['href']) : Almodovar::Resource(link['href'], @auth, options)
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
  
  class ResourceCollection < Array
    
    include HttpAccessor
    
    def initialize(auth, node, url)
      @auth = auth
      @url = url
      @object_type = node.name.singularize
      super(node.xpath("./*").map { |subnode| Resource.new(@auth, subnode) })
    end
    
    def create(attrs = {})
      response = http.resource(@url).post(attrs.to_xml(:root => @object_type), :content_type => "application/xml")
      Resource.new(@auth, Nokogiri.parse(response.body).root)
    end
    
  end
  
  class << self
    include HttpAccessor

    def Resource(url, auth, params = {})
      begin
        response = http(auth).resource(add_params(url, params)).get
        instantiate Nokogiri.parse(response.body).root, auth, url
      rescue Resourceful::UnsuccessfulHttpRequestError => e
        e.http_response.code == 404 ? nil : raise
      end
    end

    def instantiate(node, auth, url)
      if node['type'] == 'array'
        ResourceCollection.new(auth, node, url)
      else
        Resource.new(auth, node)
      end
    end

    private
    
    def add_params(url, options)
      options[:expand] = options[:expand].join(",") if options[:expand].is_a?(Array)
      params = options.map { |k, v| "#{k}=#{v}" }.join("&")
      params = "?#{params}" unless params.empty?
      url + params
    end
  end
  
end