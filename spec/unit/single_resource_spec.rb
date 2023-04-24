require 'spec_helper'

describe Almodovar::SingleResource do
  it "#update uses proper Content-Type header" do
    url = "http://movida.bebanjo.com/titles/1"

    stub_request(:put, url)

    Almodovar::SingleResource.new(url, nil).update(title: {"name" => "Kamikaze"})

    expect(a_request(:put, url).with(headers: {'Content-Type' => "application/xml"})).to have_been_made
  end

  it "#to_hash" do
    url = "http://movida.bebanjo.com/titles/1"

    stub_request(:get, url).to_return(body: %q{
      <resource type="document">
        <name>Resource Name</name>
      </resource>
    })

    expect(Almodovar::SingleResource.new(url, nil).to_hash).to eq({ "name" => "Resource Name" })
  end

  it "#delete" do
    url = "http://movida.bebanjo.com/titles/1"

    stub_request(:delete, url).to_return(status: 200)

    expect(Almodovar::SingleResource.new(url, nil).delete).to be_nil
  end

  it "#delete with query params" do
    url = "http://movida.bebanjo.com/titles/1"

    stub_request(:delete, url).with({
      query: {
        param1: 1,
        param2: 2
      }
    }).to_return(status: 200)

    expect(Almodovar::SingleResource.new(url, nil).delete({
      param1: 1,
      param2: 2
    })).to be_nil
  end
end
