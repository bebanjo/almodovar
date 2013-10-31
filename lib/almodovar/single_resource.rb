module Almodovar
  class SingleResource
    include HttpAccessor
    
    undef_method :id if instance_methods.include?("id")
    undef_method :type if instance_methods.include?("type")
        
    def initialize(url, auth, xml = nil, options = {})
      @url = url
      @auth = auth
      @xml = xml
      @options = options
    end
  
    def update(attrs = {})
      raise ArgumentError.new("You must specify one only root element which is the type of resource (e.g. `:project => { :name => 'Wadus' }` instead of just `:name => 'Wadus'`)") if attrs.size > 1
      root, body = attrs.first
      response = http.put(@url, body.to_xml(:root => root), :content_type => "application/xml")
      check_errors(response, @url)
      @xml = Nokogiri::XML.parse(response.body).root
    end
  
    def delete
      check_errors(http.delete(@url), @url)
    end
  
    def url
      @url ||= xml.at_xpath("./link[@rel='self']").try(:[], "href")
    end
  
    delegate :to_xml, :to => :xml
    alias_method :inspect, :to_xml
    
    def [](key) # for resources with type "document"
      return super unless xml.at_xpath("/*[@type='document']")
      Hash.from_xml(xml.to_xml).values.first[key]
    end
    
    def respond_to?(meth)
      super || node(meth).present? || link(meth).present?
    end
  
    private
  
    def method_missing(meth, *args, &blk)
      if node = node(meth)
        return node['type'] == 'document' ? Resource.from_xml(node.to_xml) : node_text(node)
      end
    
      link = link(meth)
      return Resource.new(link["href"], @auth, link.at_xpath("./*"), *args) if link
    
      super
    end
    
    def node(name)
      xml.at_xpath("./*[name()='#{name}' or name()='#{attribute_name(name)}']")
    end
    
    def link(name)
      xml.at_xpath("./link[@rel='#{name}' or @rel='#{attribute_name(name)}']")
    end
  
    def node_text(node)
      case node['type']
      when "integer"
        node.text.to_i
      when "datetime"
        Time.parse(node.text)
      else
        node.text
      end
    end
  
    def attribute_name(attribute)
      attribute.to_s.gsub('_', '-')
    end
  
  end
end