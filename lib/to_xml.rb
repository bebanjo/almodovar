require 'active_support/all'

module Almodovar
  
  module ToXml
    
    def to_xml_with_links(options = {})
      if options[:convert_links] && options[:builder]
        options[:builder].tag!(:link, :rel => options[:root]) do
          to_xml_without_links(options)
        end
      else
        to_xml_without_links(options)
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
  include Almodovar::ToXml
  alias_method_chain :to_xml, :links
end
