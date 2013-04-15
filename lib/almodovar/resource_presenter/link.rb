module Almodovar
  class ResourcePresenter
    class Link
      
      attr_reader :rel, :href, :expand_resource, :expand_args, :attributes
      
      def initialize(*args)
        @rel, @href, @expand_resource, @expand_args, @attributes = args
        @attributes ||= {}
      end
      
      def to_xml(options = {})
        XmlSerializer.new(self, options.merge(:skip_instruct => true)).to_xml
      end
      
      def as_json(options)
        JsonSerializer.new(self, options).as_json
      end
      
      def resource
        resource_collection? ? resource_collection : single_resource
      end
      
      def resource_collection?
        expand_args.is_a?(Array)
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
      
      class Serializer
        
        attr_reader :link, :options
        
        def initialize(link, options)
          @link = link
          @options = options
        end
        
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
        
        def to_xml
          builder.link link.attributes.merge(:rel => link.rel, :href => link.href), &expand_block
        end
        
        private
        
        def builder
          options[:builder]
        end
        
        def expand_block
          Proc.new { expand_resource } if expands?
        end

        def expand_resource
          dont_expand_link!
          link.resource.to_xml(options)
        end
        
      end
      
      class JsonSerializer < Serializer
        
        def as_json
          ActiveSupport::OrderedHash.new.tap do |message|
            message["#{link.rel}_link"] = link.href
            message[link.rel] = expand_resource if expands?
          end
        end
        
        private
        
        def expand_resource
          dont_expand_link!
          link.resource.as_json(options)
        end

      end
      
    end
  end
end
