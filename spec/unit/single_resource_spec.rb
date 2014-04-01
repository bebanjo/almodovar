require 'spec_helper'

describe Almodovar::SingleResource do

  it "#update uses proper Content-Type header" do

    stub_request(:put, "http://movida.bebanjo.com/titles/1")

    Almodovar::SingleResource.new("http://movida.bebanjo.com/titles/1", nil).update(:title => {"name" => "Kamikaze"})

    a_request(:put, "http://movida.bebanjo.com/titles/1").with(:headers => {'Content-Type' => "application/xml"}).should have_been_made
  end
end