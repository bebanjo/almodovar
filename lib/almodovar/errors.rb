module Almodovar
  class HttpError < Exception
    def initialize(response, url)
      super("Status code #{response.status} on resource #{url}")
    end
  end
end
