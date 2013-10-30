%w(serializer xml_serializer json_serializer metadata).each do |serializer|
  require "almodovar/resource_presenter/#{serializer}"
end


module Almodovar
  
  class ResourcePresenter

    extend Metadata

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
    
    def resource_class
      self.class
    end

    def resource_type
      resource_class.resource_type
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

    def to_html(options = {})
      Almodovar::Alternatives::HtmlSerialzer.new(self, options).to_html
    end
    
    def all_links
      ([link_to_self] + links).compact
    end
    
    def link_to_self
      Link.new(:self, @url) if @url
    end

  end
end