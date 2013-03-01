module Almodovar
  class ResourcePresenter
    class Serializer
      
      attr_reader :resource, :options
      
      def initialize(resource, options = {})
        @resource = resource
        @options  = options
      end

      def options_for_link
        options.merge(:dont_expand => Array(options[:dont_expand]) << resource.url)
      end

    end
  end
end
