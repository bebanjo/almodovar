module Almodovar
  class ResourcePresenter
    class XmlSerializer < Serializer
        
      def to_xml
        attributes_to_xml do |builder|
          links_to_xml builder
        end
      end
      
      private
      
      def attributes_to_xml(&block)
        resource.attributes.to_xml(options.merge(:root => resource.resource_type), &block)
      end

      def links_to_xml(builder)
        resource.all_links.each do |link|
          link.to_xml(options_for_link.merge(:builder => builder))
        end
      end

    end
  end
end
