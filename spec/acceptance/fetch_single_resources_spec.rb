require "spec_helper"

describe "Fetching individual resources" do  

  example "Fetching untyped attributes" do
    stub_auth_request(:get, "http://movida.example.com/resource").to_return(:body => %q{
      <resource>
        <name>Resource Name</name>
        <res_id>12345</res_id>
        <creation-date>2009-01-01T10:00:00Z</creation-date>
      </resource>
    })
    
    resource = Almodovar::Resource("http://movida.example.com/resource", auth)
    expect(resource.name).to eq("Resource Name")
    expect(resource.res_id).to eq("12345")
    expect(resource.creation_date).to eq("2009-01-01T10:00:00Z")
    
    expect { resource.wadus }.to raise_error(NoMethodError)
  end
  
  example "Fetching typed attributes" do
    stub_auth_request(:get, "http://movida.example.com/resource").to_return(:body => %q{
      <resource>
        <id type="integer">12345</id>
        <date type="datetime">2009-01-01T10:00:00Z</date>
        <expire-at type="date">2009-01-01</expire-at>
        <type>wadus</type>
      </resource>
    })
    
    resource = Almodovar::Resource("http://movida.example.com/resource", auth)

    expect(resource).to respond_to(:id)
    expect(resource).to respond_to(:date)
    expect(resource).to respond_to(:type)
    expect(resource).to respond_to(:expire_at)
    expect(resource).not_to respond_to(:wadus)
    
    expect(resource.id).to eq(12345)
    expect(resource.date).to eq(Time.utc(2009,1,1,10,0,0))
    expect(resource.type).to eq("wadus")
    expect(resource.expire_at).to eq(Date.parse('2009-1-1'))
  end

  example "Fetching typed attributes: array" do
    stub_auth_request(:get, "http://movida.example.com/resource").to_return(:body => %q{
      <resource>
        <cue-points type="array">
          <cue-point>00:07:00</cue-point>
          <cue-point>00:14:00</cue-point>
        </cue-points>
      </resource>
    })

    resource = Almodovar::Resource("http://movida.example.com/resource", auth)

    expect(resource).to respond_to(:'cue-points')
    expect(resource).not_to respond_to(:wadus)

    expect(resource.cue_points).to eq(["00:07:00", "00:14:00"])
    expect(resource.cue_points[0]).to eq("00:07:00")
    expect(resource.cue_points[1]).to eq("00:14:00")
    expect(resource.cue_points.length).to eq(2)
  end

  example "Inspecting a resource" do
    xml = %q{
      <resource>
        <id type="integer">12345</id>
        <date type="datetime">2009-01-01T10:00:00Z</date>
      </resource>      
    }
    stub_auth_request(:get, "http://movida.example.com/resource").to_return(:body => xml)
    
    resource = Almodovar::Resource("http://movida.example.com/resource", auth)

    expect(Nokogiri::XML.parse(resource.inspect).to_xml).to eq(Nokogiri::XML.parse(xml).to_xml)
  end
  
  example "Using a port different than default" do
    stub_auth_request(:get, "http://movida.example.com:3000/resource").to_return(:body => %q{
      <resource>
        <name>Resource Name</name>
      </resource>
    })
    
    resource = Almodovar::Resource("http://movida.example.com:3000/resource", auth)
    expect(resource.name).to eq("Resource Name")
  end
  
end
