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
             :send_timeout=,
             :receive_timeout=,
             :force_basic_auth=,
             to: :client

    def initialize
      @client = HTTPClient.new
    end

    def get(uri, query = {}, headers = {})
      request(:get, uri, query: query, headers: merge_headers(headers))
    end

    def post(uri, data, query = {}, headers = {})
      request(:post, uri, body: data, query: query, headers: merge_headers(headers))
    end

    def put(uri, data, query = {}, headers = {})
      request(:put, uri, body: data, query: query, headers: merge_headers(headers))
    end

    def delete(uri, query = {}, headers = {})
      request(:delete, uri, query: query, headers: merge_headers(headers))
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
        set_client_auth(domain)
      end
      request_options = {
        body: options[:body],
        header: options[:headers].stringify_keys || {},
        follow_redirect: true
      }
      request_options[:query] = options[:query] if options[:query].present?
      client.request(method, uri, request_options)
    rescue HTTPClient::SendTimeoutError => e
      raise SendTimeoutError.new(e)
    rescue HTTPClient::ReceiveTimeoutError => e
      raise ReceiveTimeoutError.new(e)
    rescue HTTPClient::ConnectTimeoutError => e
      raise ConnectTimeoutError.new(e)
    rescue HTTPClient::TimeoutError => e
      raise TimeoutError.new(e)
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
