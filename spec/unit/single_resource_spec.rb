require 'spec_helper'

describe Almodovar::SingleResource do

  it "#update uses proper Content-Type header" do

    stub_request(:put, "http://movida.bebanjo.com/titles/1")

    Almodovar::SingleResource.new("http://movida.bebanjo.com/titles/1", nil).update(title: {"name" => "Kamikaze"})

    expect(a_request(:put, "http://movida.bebanjo.com/titles/1").with(headers: {'Content-Type' => "application/xml"})).to have_been_made
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
end
