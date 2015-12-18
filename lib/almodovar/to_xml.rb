module Almodovar
  module ToXml
    def self.included(base)
      base.alias_method_chain :to_xml, :links
    end

    def to_xml_with_links(options = {}, &block)
      return to_xml_without_links(options, &block) if !options[:convert_links] || options.delete(:skip_links_one_level)
      options[:builder].tag!(:link, :rel => options[:root]) do |xml|
        to_xml_without_links options.merge(:skip_links_one_level => self.is_a?(Array)), &block
      end
    end
  end

  class Resource
    def to_xml(options = {})
      options[:builder].tag!(:link, :rel => options[:root], :href => url)
    end
  end

  class SingleResource
    def to_xml(options = {})
      options[:builder].tag!(:link, :rel => options[:root], :href => url)
    end
  end
end

Array.send :include, Almodovar::ToXml
Hash.send :include, Almodovar::ToXml
