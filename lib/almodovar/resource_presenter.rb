module Almodovar
  class ResourcePresenter
    
    attr_writer :url
    
    def attributes
      @attributes ||= ActiveSupport::OrderedHash.new
    end
    
    def links
      @links ||= []
    end

    def to_xml(options = {})
      attributes.to_xml(options.merge(:root => resource_type)) do |builder|
        links_to_xml(options.merge(:builder => builder))
      end
    end

    private
    
    def links_to_xml(options)
      all_links = ([link_to_self] + links).compact
      
      all_links.each do |link|
        link.to_xml(options.merge(:dont_expand => Array(options[:dont_expand]) << @url))
      end
    end
    
    def link_to_self
      Link.new(:self, @url) if @url
    end

    def resource_type
      self.class.resource_type
    end
    
    def self.resource_type
      name.gsub(/Resource$/, '').underscore
    end

  end
end