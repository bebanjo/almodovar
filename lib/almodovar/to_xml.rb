module Almodovar
  module ToXml
    def to_xml(options = {}, &block)
      return super(options, &block) if !options[:convert_links] || options.delete(:skip_links_one_level)
      options[:builder].tag!(:link, rel: options[:root]) do |xml|
        super options.merge(skip_links_one_level: self.is_a?(Array)), &block
      end
    end
  end

  class Resource
    def to_xml(options = {})
      options[:builder].tag!(:link, rel: options[:root], href: url)
    end
  end
end

Array.send :prepend, Almodovar::ToXml
Hash.send :prepend, Almodovar::ToXml
