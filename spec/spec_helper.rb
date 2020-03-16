require 'rubygems'
require 'webmock/rspec'
require 'almodovar'

module Helpers

  def parse_json(json)
    JSON.parse(json)
  end

  def stub_auth_request(method, url)
    stub_request(method, url).with(basic_auth: [auth.username, auth.password])
  end

  def auth_request(method, url)
    a_request(method, url).with(basic_auth: [auth.username, auth.password])
  end

  def auth
    @auth ||= Almodovar::DigestAuth.new("realm", "user", "password")
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.include WebMock::API
  config.before(:each) do
    Almodovar.reset_options
    WebMock.reset!
  end
  config.before(:each) do |example|
    unless example.metadata[:skip_force_basic_auth]
      Almodovar.default_options = { force_basic_auth: true }
    end
  end
end
