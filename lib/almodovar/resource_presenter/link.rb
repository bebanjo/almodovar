module Almodovar
  
  class ResourcePresenter::Link < Struct.new(:rel, :href, :expand_resource, :expand_args)
    
    def to_xml(options = {})
      XmlSerializer.new(self, options.merge(:skip_instruct => true)).serialize
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
    
    class XmlSerializer < Struct.new(:link, :options)
      
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
        link.resource.to_xml(options.merge(:dont_expand => Array(options[:dont_expand]) << link.href))
      end

      def expands?
        link.expand_resource? && 
        Array(options[:expand]).include?(link.rel) && 
        !Array(options[:dont_expand]).include?(link.href)
      end
      
    end
    
  end

end