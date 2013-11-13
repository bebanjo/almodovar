module Almodovar
  class ResourcePresenter
    class Collection

      attr_reader :resource_class
      
      def initialize(resource_class, resources_args = [], options = {})
        @resource_class = resource_class
        @resources = resources_args.map { |arg| @resource_class.new(arg) }
        
        @total = options[:total_entries]
        @next = options[:next_link]
        @prev = options[:prev_link]
      end
      
      def to_xml(options = {})
        # Most of the following code is borrowed from ActiveSupport's Array#to_xml.
        # We cannot use Array#to_xml because we need to add a few custom tags for
        # pagination.
        require 'active_support/builder' unless defined?(Builder)

        options = options.dup
        options[:indent]  ||= 2
        options[:builder] ||= ::Builder::XmlMarkup.new(:indent => options[:indent])

        xml = options[:builder]

        xml.instruct! unless options[:skip_instruct]
        xml.tag! resource_type.pluralize.dasherize, :type => 'array' do
          xml.tag!('total-entries', @total) if @total
          prev_link.to_xml(:builder => xml) if prev_link
          next_link.to_xml(:builder => xml) if next_link
          @resources.each { |value| value.to_xml(options.merge(:root => resource_type.singularize, :skip_instruct => true)) }
        end
      end
      
      def as_json(options = {})
        message = ActiveSupport::OrderedHash.new.tap do |message|
          message[:total_entries] = @total if @total
          message.merge! prev_link.as_json if prev_link
          message.merge! next_link.as_json if next_link 
          message[:entries] = @resources.map { |resource| resource.as_json(options) }
        end
      end
      
      def to_json(options = {})
        require 'yajl'
        Yajl::Encoder.encode(as_json(options), :pretty => true) + "\n"
      end

      def to_html(options = {})
        HtmlSerializer.new(self, options).to_html
      end
      
      def resource_type
        @resource_class.resource_type
      end

      def next_link
        Link.new(:next, @next) if @next
      end

      def prev_link
        Link.new(:prev, @prev) if @prev
      end

    end
  end  
end
