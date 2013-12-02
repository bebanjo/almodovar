require 'json/pure'

module Almodovar
  module Alternatives
    module PureRuby

      class JSONParser

        class << self
          def parse(json)
            JSON.parse(json)
          end
        end
      end

    end
  end
end