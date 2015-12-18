require 'spec_helper'

describe Almodovar::SingleResource do

  it "#update uses proper Content-Type header" do

    stub_request(:put, "http://movida.bebanjo.com/titles/1")

    Almodovar::SingleResource.new("http://movida.bebanjo.com/titles/1", nil).update(:title => {"name" => "Kamikaze"})

    a_request(:put, "http://movida.bebanjo.com/titles/1").with(:headers => {'Content-Type' => "application/xml"}).should have_been_made
  end

  context "#links" do
    before do
      @single_resource = Almodovar::SingleResource.new("http://movida.bebanjo.com/titles/1", nil)
    end

    it "return the same single resource instance" do
      single_resource = @single_resource.links

      expect(single_resource.class).to eq(Almodovar::SingleResource)
    end

    it "set links" do
      expected_links  = [{ rel: "series", href: "http://example.com/api/series/1" }]
      single_resource = @single_resource.links(expected_links)

      expect(single_resource.instance_variable_get(:@links)).to eq(expected_links)
    end

    it "return xml with links" do
      expected_links    = [{ rel: "series", href: "http://example.com/api/series/1" }]
      xml_without_links = { "name" => "Kamikaze" }.to_xml(root: "title")
      built_xml         = @single_resource.links(expected_links).send(:build_body, xml_without_links)

      link_node = Nokogiri::XML.parse(built_xml).xpath("//title//link").first
      expect(Nokogiri::XML.parse(built_xml).xpath("//title//link").count).to eq(1)
      expect(link_node.name).to eq("link")
      expect(link_node.attributes["rel"].name).to eq("rel")
      expect(link_node.attributes["rel"].value).to eq("series")
      expect(link_node.attributes["href"].name).to eq("href")
      expect(link_node.attributes["href"].value).to eq("http://example.com/api/series/1")
    end

    it "return xml without links" do
      xml_without_links = { "name" => "Kamikaze" }.to_xml(root: "title")
      built_xml         = @single_resource.send(:build_body, xml_without_links)

      expect(Nokogiri::XML.parse(built_xml).xpath("//title//link").count).to eq(0)
    end
  end
end
