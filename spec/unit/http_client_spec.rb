require 'spec_helper'

describe Almodovar::HttpClient do

  it "merges session headers with request headers" do
    stub_request(:get, "http://www.bebanjo.com/")

    client = Almodovar::HttpClient.new.tap do |client|
      client.headers = {'Foo' => 'Bar', 'Baz' => 'Bas'}
    end

    client.get("http://www.bebanjo.com", 'Baz' => 'Oink')

    a_request(:get, "http://www.bebanjo.com").with(:headers => {'Foo' => 'Bar', 'Baz' => 'Oink'}).should have_been_made
  end

  it "allows URI escaped characters in password" do
    stub_request(:get, "http://username:%5B%5D@www.bebanjo.com/")

    client = Almodovar::HttpClient.new.tap do |client|
      client.username = 'username'
      client.password = '[]'
    end

    client.get("http://www.bebanjo.com")

    a_request(:get, "http://username:%5B%5D@www.bebanjo.com").should have_been_made
  end
end
