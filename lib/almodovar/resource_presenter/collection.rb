module Almodovar
  
  class ResourcePresenter::Collection
    
    def initialize(resource_class, resources_args = [])
      @resource_class = resource_class
      @resources = resources_args.map { |arg| @resource_class.new(arg) }
    end
    
    def to_xml(options = {})
      @resources.to_xml(options.merge({:root => resource_type.pluralize}))
    end
    
    def resource_type
      @resource_class.resource_type
    end

  end
  
end