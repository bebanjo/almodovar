module Almodovar
  module HttpAccessor
    def xml
      @xml ||= begin
        response = http.get(url_with_params)
        Nokogiri::XML.parse(response.body).root
      end
    end
    
    def url_with_params
      @options[:expand] = @options[:expand].join(",") if @options[:expand].is_a?(Array)
      params = @options.map { |k, v| "#{k}=#{v}" }.join("&")
      params = "?#{params}" unless params.empty?
      @url + params
    end
    
    def http
      @http ||= Patron::Session.new.tap do |session|
        session.username = @auth.username
        session.password = @auth.password
        session.auth_type = :digest
      end
    end
  end
  
end