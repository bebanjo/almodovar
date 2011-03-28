module Almodovar
  class Resource
    include HttpAccessor
  
    undef id, type
  
    delegate :inspect, :to => :get!
  
    def self.from_xml(xml, auth = nil)
      new(nil, auth, Nokogiri::XML.parse(xml).root)
    end
  
    def initialize(url, auth, xml = nil, options = {})
      @url = url
      @auth = auth
      @xml = xml
      @options = options
    end
  
    def method_missing(meth, *args, &blk)
      resource_object(meth).send(meth, *args, &blk)
    end
    
    def get!
      klass = xml['type'] == 'array' ? ResourceCollection : SingleResource
      @resource_object = klass.new(@url, @auth, @xml, @options)
    end
    
    def respond_to?(meth)
      super || resource_object(meth).respond_to?(meth)
    end
  
    private
  
    def collection_call?(meth, *args)
      (Array.instance_methods + ["create"] - ["delete", "id", "[]"]).include?(meth.to_s) ||
      (meth.to_s == "[]" && args.size == 1 && args.first.is_a?(Fixnum))
    end
    
    def resource_object(meth)
      @resource_object ||= resource_class(meth).new(@url, @auth, @xml, @options)
    end
  
    def resource_class(meth, *args)
      @resource_class ||= collection_call?(meth, *args) ? ResourceCollection : SingleResource
    end
  
  end
  
  def self.Resource(url, auth = nil, params = {})
    Resource.new(url, auth, nil, params)
  end
  
end