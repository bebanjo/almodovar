require 'spec_helper'

describe Almodovar::HttpClient do

  it "merges session headers with request headers" do
    stub_request(:get, "http://www.bebanjo.com/")

    client = Almodovar::HttpClient.new.tap do |client|
      client.headers = {'Foo' => 'Bar', 'Baz' => 'Bas'}
    end

    client.get("http://www.bebanjo.com", {}, {'Baz' => 'Oink'})

    expect(a_request(:get, "http://www.bebanjo.com").with(headers: {'Foo' => 'Bar', 'Baz' => 'Oink'})).to have_been_made
  end

  it "merges default headers with request headers" do
    stub_request(:get, "http://www.bebanjo.com/")

    default_headers = {'Foo' => 'Bar', 'Baz' => 'Bas'}
    allow(Almodovar).to receive(:default_options).and_return(headers: default_headers)

    client = Almodovar::HttpClient.new
    client.get("http://www.bebanjo.com", {}, {'Baz' => 'Oink'})

    expect(a_request(:get, "http://www.bebanjo.com").with(headers: {'Foo' => 'Bar', 'Baz' => 'Oink'})).to have_been_made
  end

  it "merges default headers with session headers with request headers" do
    stub_request(:get, "http://www.bebanjo.com/")

    default_headers = {'Chaflan' => 'Wadus', 'Foo' => 'Bing'}
    allow(Almodovar).to receive(:default_options).and_return(headers: default_headers)

    client = Almodovar::HttpClient.new.tap do |client|
      client.headers = {'Foo' => 'Bar', 'Baz' => 'Bas'}
    end

    client.get("http://www.bebanjo.com", {}, {'Baz' => 'Oink'})

    expect(a_request(:get, "http://www.bebanjo.com").with(headers: {'Chaflan' => 'Wadus', 'Foo' => 'Bar', 'Baz' => 'Oink'})).to have_been_made
  end

  it "evaluates default headers per request" do
    stub_request(:get, "http://www.bebanjo.com/")

    counter = 0
    default_headers = Proc.new { { 'X-Counter' => (counter += 1) } }
    allow(Almodovar).to receive(:default_options).and_return(headers: default_headers)

    client = Almodovar::HttpClient.new
    client.get("http://www.bebanjo.com")
    expect(a_request(:get, "http://www.bebanjo.com").with(headers: {'X-Counter' => 1})).to have_been_made

    client.get("http://www.bebanjo.com")
    expect(a_request(:get, "http://www.bebanjo.com").with(headers: {'X-Counter' => 2})).to have_been_made
  end

  it "allows URI escaped characters in password" do
    stub_request(:get, "http://www.bebanjo.com/")

    client = Almodovar::HttpClient.new.tap do |client|
      client.force_basic_auth = true
      client.username = 'username'
      client.password = '[]'
    end

    client.get("http://www.bebanjo.com")

    expect(a_request(:get, "http://www.bebanjo.com").with(basic_auth: ['username', '[]'])).to have_been_made
  end
end
