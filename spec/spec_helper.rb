require 'rubygems'
require 'steak'
require 'webmock/rspec'
require "almodovar"

module Helpers  
  def stub_auth_request(*args)
    stub_request(*args).with(:headers => {"Authorization" => /^Digest/ })
  end
  
  def auth_request(*args)
    request(*args).with(:headers => {"Authorization" => /^Digest/ })
  end
  
  def auth
    Almodovar::DigestAuth.new("realm", "user", "password")
  end
end

Spec::Runner.configure do |config|
  config.include Helpers
  config.include WebMock
  config.before(:each) do
    stub_request(:any, //).with { |request| !request.headers.has_key?("Authorization") }.
                           to_return(
                             :status => 401, :headers => {
                               "WWW-Authenticate" => 'Digest realm="realm", qop="auth", algorithm=MD5, nonce="MTI3MDczNjM0NTpiNjQ5MDNkMzMyNDVhYWE0M2M2OWRiYmJmNDU2MjhlMg==", opaque="0b3ab90874517ff5f4ea48fe15f49f8c"'
                            })
  end
  config.after(:each) { reset_webmock }
end