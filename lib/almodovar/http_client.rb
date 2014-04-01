require 'httpclient'

module Almodovar
  class HttpClient

    attr_accessor :client,
                  :headers,
                  :username,
                  :password,
                  :auth_type

    delegate :agent_name=,
             :connect_timeout=,
             :to => :client


    def timeout=(value)
      client.send_timeout = value
    end

    def initialize
      @client = HTTPClient.new
    end

    def get(uri, headers = {})
      request(:get, uri, :headers => merge_headers(headers))
    end

    def post(uri, data, headers = {})
      request(:post, uri, :body => data, :headers => merge_headers(headers))
    end

    def put(uri, data, headers = {})
      request(:put, uri, :body => data, :headers => merge_headers(headers))
    end

    def delete(uri, headers = {})
      request(:delete, uri, :headers => merge_headers(headers))
    end

    private

    def merge_headers(headers)
      (self.headers ||= {}).merge(headers)
    end

    def requires_auth?
      username && password
    end

    def domain_for(uri)
      scheme_chunk = uri.scheme ? "#{uri.scheme}://" : ''
      port_chunk = uri.port ? ":#{uri.port}" : ''
      host_chunk = uri.host.downcase
      "#{scheme_chunk}#{host_chunk}#{port_chunk}"
    end

    def previous_context
      @previous_auth_context
    end

    def previous_context=(context)
      @previous_auth_context = context
    end

    def set_client_auth(domain)
      context = AuthContext.new(username, password, domain)
      if (context.differs_from?(previous_context))
        client.set_auth(domain, username, password)
      end
    end

    def request(method, uri, options = {})
      uri = URI.parse(uri)
      if (requires_auth?)
        domain = domain_for(uri)
        uri.user = username
        uri.password = password
        set_client_auth(domain)
      end
      client.request(method, uri, :body => options[:body], :header => options[:headers].stringify_keys || {}, :follow_redirect => true)
    end
  end

  class AuthContext
    attr_accessor :username, :password, :domain

    def initialize(username, password, domain)
      @username = username
      @password = password
      @domain = domain
    end

    def differs_from?(other)
      return true if other.nil?
      (username != other.username) || (password != other.password) || (domain != other.domain)
    end
  end

  class HttpResponse
    attr_accessor :status, :body
  end

end