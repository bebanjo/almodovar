module Almodovar
  class ResourceCollection
    include HttpAccessor
    include Enumerable
    
    PAGINATION_ENTITIES = ["self::total-entries", "self::link[@rel='next']", "self::link[@rel='prev']"].join('|').freeze

    delegate :inspect, to: :resources

    def initialize(url, auth, xml = nil, options = {})
      @url = url
      @auth = auth
      @xml = xml if options.empty?
      @options = options
    end
    
    def create(attrs = {})
      raise ArgumentError.new("You must specify one only root element which is the type of resource (e.g. `:project => { :name => 'Wadus' }` instead of just `:name => 'Wadus'`)") if attrs.size > 1
      root, body = attrs.first
      response = http.post(url_with_params, body.to_xml(root: root, convert_links: true, skip_links_one_level: true), "Content-Type" => "application/xml")
      check_errors(response, url_with_params)
      Resource.new(nil, @auth, Nokogiri::XML.parse(response.body).root)
    end

    def total_entries
      @total_entries ||= xml.at_xpath("./total-entries").try(:text).try(:to_i) || resources.size
    end

    def next_url
      @next_url ||= xml.at_xpath("./link[@rel='next']").try(:[], "href")
    end

    def prev_url
      @prev_url ||= xml.at_xpath("./link[@rel='prev']").try(:[], "href")
    end

    def next_page
      Resource.new(next_url, @auth) if next_url
    end

    def prev_page
      Resource.new(prev_url, @auth) if prev_url
    end
    
    private
    
    def resources
      @resources ||= begin
        xml.xpath("./*[not(#{PAGINATION_ENTITIES})]").
          map { |subnode| Resource.new(subnode.at_xpath("./link[@rel='self']").try(:[], "href"), @auth, subnode, @options) }
      end
    end
    
    def method_missing(meth, *args, &blk)
      resources.send(meth, *args, &blk)
    end
  end
end