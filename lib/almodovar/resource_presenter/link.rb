module Almodovar
  
  class ResourcePresenter::Link < Struct.new(:rel, :href, :expand_resource, :expand_args)
    
    def to_xml(options = {})
      XmlSerializer.new(self, options.merge(:skip_instruct => true)).serialize
    end
    
    def as_json(options)
      JSONSerializer.new(self, options).as_json
    end
    
    def resource_collection?
      expand_args.is_a?(Array)
    end
    
    def resource_type
      expand_resource.resource_type
    end
    
    def resource
      resource_collection? ? resource_collection : single_resource
    end
    
    def resource_collection
      ResourcePresenter::Collection.new(expand_resource, expand_args)
    end
    
    def single_resource
      expand_resource.new(*[expand_args].compact)        
    end
    
    def expand_resource?
      expand_resource.present?
    end
    
    class Serializer < Struct.new(:link, :options)
      
      def expands?
        link.expand_resource? && 
        Array(options[:expand]).include?(link.rel) && 
        !Array(options[:dont_expand]).include?(link.href)
      end
      
      def dont_expand_link!
        (options[:dont_expand] ||= []) << link.href
      end
      
    end
    
    class XmlSerializer < Serializer
      
      def serialize
        builder.link :rel => link.rel, :href => link.href, &expand_block
      end
      
      private
      
      def builder
        options[:builder]
      end
      
      def expand_block
        lambda { expand_resource } if expands?
      end

      def expand_resource
        dont_expand_link!
        link.resource.to_xml(options)
      end
      
    end
    
    class JSONSerializer < Serializer
      
      def as_json
        ActiveSupport::OrderedHash.new.tap do |message|
          message["#{link.rel}_link"] = link.href
          message[link.rel] = expand_resource if expands?
        end
      end
      
      def expand_resource
        dont_expand_link!
        link.resource.as_json(options)
      end

    end
    
  end

end