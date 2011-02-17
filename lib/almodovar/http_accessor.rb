module Almodovar
  module HttpAccessor  
    def xml
      @xml ||= begin
        response = http.resource(url_with_params).get
        Nokogiri.parse(response.body).root
      end
    end
  
    private
  
    def url_with_params
      @options[:expand] = @options[:expand].join(",") if @options[:expand].is_a?(Array)
      params = @options.map { |k, v| "#{k}=#{v}" }.join("&")
      params = "?#{params}" unless params.empty?
      @url + params
    end
  
    def http
      Resourceful::HttpAccessor.new(:authenticator => @auth)
    end
  end
end