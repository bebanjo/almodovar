module Almodovar
  class ResourcePresenter
    class JsonSerializer < Serializer
        
      def to_json
        require 'yajl'
        Yajl::Encoder.encode(as_json, :pretty => true) + "\n"
      end
      
      def as_json
        ActiveSupport::OrderedHash[:resource_type, resource.resource_type].tap do |message|
          message.merge! attributes_as_json
          message.merge! links_as_json
        end
      end
      
      private
      
      def attributes_as_json
        resource.attributes
      end

      def links_as_json
        resource.all_links.inject(ActiveSupport::OrderedHash.new) do |message, link|
          message.merge! link.as_json(options_for_link)
        end
      end
        
    end
  end
end
