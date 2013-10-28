module Almodovar::Alternatives

  class JSONEncoder

    class << self
      def encode(object, options = {})
        if (options[:pretty])
          JSON.pretty_generate(object) + "\n"
        else
          JSON.generate(object) + "\n"
        end
      end
    end

  end
end