module Almodovar::Alternatives

  class JSONParser

    class << self
      def parse(json)
        JSON.parse(json)
      end
    end

  end
end