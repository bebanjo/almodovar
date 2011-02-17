require 'active_support/all'

module Almodovar
  module ArrayToXml
    def to_xml(options = {})
      return super unless options[:convert_links]
      options[:builder].tag!(:link, :rel => options[:root]) { super }
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
end
