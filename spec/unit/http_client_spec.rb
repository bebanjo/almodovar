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
end