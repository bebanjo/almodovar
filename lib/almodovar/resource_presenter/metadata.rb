module Almodovar
  class ResourcePresenter
    module Metadata

      def inherited(base)
        base.metadata[:name] = base.name.demodulize.titleize
      end

      def desc(description)
        metadata[:desc] = description
      end

      def link(name, options)
        metadata[:links][name] = options
      end

      def attribute(name, options)
        metadata[:attributes][name] = options
      end

      def metadata
        @metadata ||= Hash.new {|h,a| h[a] = ActiveSupport::OrderedHash.new}
      end

    end
  end
end
