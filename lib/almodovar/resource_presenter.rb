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
      attributes_to_xml(options.merge(:root => resource_type)) do |builder|
        links_to_xml(options.merge(:builder => builder))
      end
    end
    
    def to_json(options = {})
      require 'yajl'
      Yajl::Encoder.encode(as_json(options), :pretty => true) + "\n"
    end
    
    def as_json(options = {})
      ActiveSupport::OrderedHash[:resource_type, resource_type].tap do |message|
        message.merge! attributes_as_json
        message.merge! links_as_json(options)
      end
    end

    private
    
    def attributes_to_xml(options, &block)
      attributes.to_xml(options, &block)
    end
    
    def links_to_xml(options)
      all_links.each do |link|
        link.to_xml(options_for_link(options))
      end
    end

    def attributes_as_json
      attributes
    end
    
    def links_as_json(options = {})
      all_links.inject(ActiveSupport::OrderedHash.new) do |message, link|
        message.merge! link.as_json(options_for_link(options))
      end
    end
    
    def options_for_link(options)
      options.merge(:dont_expand => Array(options[:dont_expand]) << @url)
    end

    def all_links
      ([link_to_self] + links).compact
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