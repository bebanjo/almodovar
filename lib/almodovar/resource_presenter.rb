module Almodovar
  
  class ResourcePresenter
    
    attr_accessor :url
    
    def attributes
      @attributes ||= ActiveSupport::OrderedHash.new
    end
    
    def links
      @links ||= []
    end
    
    def self.resource_type
      name.gsub(/Resource$/, '').underscore
    end
    
    def resource_type
      self.class.resource_type
    end

    def to_xml(options = {})
      XmlSerializer.new(self, options).to_xml
    end
    
    def to_json(options = {})
      JsonSerializer.new(self, options).to_json
    end
    
    def as_json(options = {})
      JsonSerializer.new(self, options).as_json
    end
    
    def all_links
      ([link_to_self] + links).compact
    end
    
    def link_to_self
      Link.new(:self, @url) if @url
    end
    
    class Serializer
      
      attr_reader :resource, :options
      
      def initialize(resource, options)
        @resource = resource
        @options  = options
      end

      def options_for_link
        options.merge(:dont_expand => Array(options[:dont_expand]) << resource.url)
      end
      
    end
    
    class XmlSerializer < Serializer
      
      def to_xml
        attributes_to_xml do |builder|
          links_to_xml builder
        end
      end
      
      private
      
      def attributes_to_xml(&block)
        resource.attributes.to_xml(options.merge(:root => resource.resource_type), &block)
      end

      def links_to_xml(builder)
        resource.all_links.each do |link|
          link.to_xml(options_for_link.merge(:builder => builder))
        end
      end

    end
    
    class JsonSerializer < Serializer
      
      def to_json
        require 'yajl'
        Yajl::Encoder.encode(as_json, :pretty => true) + "\n"
      end
      
      def as_json
        ActiveSupport::OrderedHash[:resource_type, resource.resource_type].tap do |message|
          message.merge! attributes_as_json
          message.merge! links_as_json
        end
      end
      
      private
      
      def attributes_as_json
        resource.attributes
      end

      def links_as_json
        resource.all_links.inject(ActiveSupport::OrderedHash.new) do |message, link|
          message.merge! link.as_json(options_for_link)
        end
      end
      
    end

  end
  
end