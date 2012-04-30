module Almodovar
  module ArrayToXml
    def to_xml_with_links(options = {}, &block)
      return to_xml_without_links(options, &block) unless options[:convert_links]
      options[:builder].tag!(:link, :rel => options[:root]) do |xml|
        to_xml_without_links options.merge(:builder => xml), &block
      end
    end
  end
  
  class Resource
    def to_xml(options = {})
      options[:builder].tag!(:link, :rel => options[:root], :href => url)
    end
  end
end

class Array
  include Almodovar::ArrayToXml
  alias_method_chain :to_xml, :links
end
