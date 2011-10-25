module Almodovar
  class ResourceCollection
    include HttpAccessor
    
    delegate :inspect, :to => :resources
    
    def initialize(url, auth, xml = nil, options = {})
      @url = url
      @auth = auth
      @xml = xml if options.empty?
      @options = options
    end
    
    def create(attrs = {})
      raise ArgumentError.new("You must specify one only root element which is the type of resource (e.g. `:project => { :name => 'Wadus' }` instead of just `:name => 'Wadus'`)") if attrs.size > 1
      root, body = attrs.first
      response = http.post(url_with_params, body.to_xml(:root => root, :convert_links => true), :content_type => "application/xml")
      check_errors(response)
      Resource.new(nil, @auth, Nokogiri::XML.parse(response.body).root)
    end
    
    private
    
    def resources
      @resources ||= xml.xpath("./*").map { |subnode| Resource.new(subnode.at_xpath("./link[@rel='self']").try(:[], "href"), @auth, subnode, @options) }
    end
    
    def method_missing(meth, *args, &blk)
      resources.send(meth, *args, &blk)
    end
  end
end