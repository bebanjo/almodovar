module Almodovar
  class HttpError < StandardError
    attr_reader :response_status, :response_body

    def initialize(response, url)
      @response_status = response.status
      @response_body = response.body
      super("Status code #{response.status} on resource #{url}")
    end
  end

  class TimeoutError < StandardError
  end
end
