require 'json/pure'

module Almodovar
  module Alternatives
    module PureRuby

      class JSONEncoder

        class << self
          def encode(object, options = {})
            if (options[:pretty])
              JSON.pretty_generate(object)
            else
              JSON.generate(object) + "\n"
            end
          end
        end
      end

    end
  end
end