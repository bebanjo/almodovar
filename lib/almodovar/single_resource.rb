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
      response = http.put(@url, body.to_xml(root: root), {}, { "Content-Type" => "application/xml" })
      check_errors(response, @url)
      @xml = Nokogiri::XML.parse(response.body).root
    end

    def delete(extra_query_params = {})
      check_errors(http.delete(@url, extra_query_params), @url, extra_query_params)
    end

    def url
      @url ||= xml.at_xpath("./link[@rel='self']").try(:[], "href")
    end

    def to_hash
      xml_without_type = xml.dup.tap do |xml|
        xml.delete("type")
      end

      if xml_without_type.content.strip.empty?
        {}
      else
        xml_hash = Hash.from_xml(xml_without_type.to_s)
        xml_hash[xml_without_type.name]
      end
    end

    delegate :to_xml, to: :xml
    alias_method :inspect, :to_xml

    def [](key) # for resources with type "document"
      return super unless xml.at_xpath("/*[@type='document']")
      Hash.from_xml(xml.to_xml).values.first[key]
    end

    def respond_to?(meth, include_all=false)
      super || (node(meth) != nil) || (link(meth) != nil)
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
      when "date"
        Date.parse(node.text)
      when "array"
        return node.element_children.map { |c| node_text(c) }
      else
        node.text
      end
    end

    def attribute_name(attribute)
      attribute.to_s.gsub('_', '-')
    end

  end
end
