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
  config.before(:suite) do
    $default_options = Almodovar.default_options.dup
  end
  config.before(:each) do |example|
    unless example.metadata[:skip_force_basic_auth]
      Almodovar.default_options = $default_options.merge(force_basic_auth: true)
    end
  end
  config.after(:each) do
    WebMock.reset!
    Almodovar.default_options = $default_options
  end
end
