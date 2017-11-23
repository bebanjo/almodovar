module Almodovar
  module HttpAccessor
    def xml
      @xml ||= begin
        response = http.get(url_with_params)
        check_errors(response, url_with_params)
        Nokogiri::XML.parse(response.body).root
      end
    end

    def url_with_params
      @options[:expand] = @options[:expand].join(",") if @options[:expand].is_a?(Array)
      params = @options.to_query
      params = "?#{params}" unless params.empty?
      @url + params
    end

    def http
      @http ||= Almodovar::HttpClient.new.tap do |session|
        session.send_timeout = Almodovar::default_options[:send_timeout]
        session.connect_timeout = Almodovar::default_options[:connect_timeout]
        session.receive_timeout = Almodovar::default_options[:receive_timeout]
        session.agent_name = Almodovar::default_options[:user_agent]

        if @auth
          session.force_basic_auth = Almodovar::default_options[:force_basic_auth]
          session.username = @auth.username
          session.password = @auth.password
          session.auth_type = :digest
        end
      end
    end

    def check_errors(response, url)
      if response.status >= 400
        http_error_klass = Almodovar::HTTP_ERRORS[response.status] || Almodovar::HttpError
        raise http_error_klass.new(response, url)
      end
    end
  end
end
