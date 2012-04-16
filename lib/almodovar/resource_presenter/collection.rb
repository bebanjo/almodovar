module Almodovar
  
  class ResourcePresenter::Collection
    
    def initialize(resource_class, resources_args = [], options = {})
      @resource_class = resource_class
      @resources = resources_args.map { |arg| @resource_class.new(arg) }
      
      @total = options[:total_entries]
      @next = options[:next_link]
      @prev = options[:prev_link]
    end
    
    def to_xml(options = {})
      @resources.to_xml(options.merge({:root => resource_type.pluralize})) do |xml|
        xml.tag!('total-entries', @total) if @total
        xml.link :rel => 'next', :href => @next if @next
        xml.link :rel => 'prev', :href => @prev if @prev
      end
    end
    
    def as_json(options = {})
      ActiveSupport::OrderedHash.new.tap do |message|
        message[:total_entries] = @total if @total
        message[:next_link] = @next if @next
        message[:prev_link] = @prev if @prev
        message[:entries] = @resources.map { |resource| resource.as_json(options) }
      end
    end
    
    def to_json(options = {})
      require 'yajl'
      Yajl::Encoder.encode(as_json(options), :pretty => true) + "\n"
    end
    
    def resource_type
      @resource_class.resource_type
    end

  end
  
end