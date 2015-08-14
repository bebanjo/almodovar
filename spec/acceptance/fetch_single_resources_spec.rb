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
    resource.name.should == "Resource Name"
    resource.res_id.should == "12345"
    resource.creation_date.should == "2009-01-01T10:00:00Z"
    
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

    resource.should respond_to(:id)
    resource.should respond_to(:date)
    resource.should respond_to(:type)
    resource.should respond_to(:expire_at)
    resource.should_not respond_to(:wadus)
    
    resource.id.should == 12345
    resource.date.should == Time.utc(2009,1,1,10,0,0)
    resource.type.should == "wadus"
    resource.expire_at.should == Date.parse('2009-1-1')
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

    resource.should respond_to(:'cue-points')
    resource.should_not respond_to(:wadus)

    resource.cue_points.should == ["00:07:00", "00:14:00"]
    resource.cue_points[0].should == "00:07:00"
    resource.cue_points[1].should == "00:14:00"
    resource.cue_points.length.should == 2
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

    Nokogiri::XML.parse(resource.inspect).to_xml.should == Nokogiri::XML.parse(xml).to_xml
  end
  
  example "Using a port different than default" do
    stub_auth_request(:get, "http://movida.example.com:3000/resource").to_return(:body => %q{
      <resource>
        <name>Resource Name</name>
      </resource>
    })
    
    resource = Almodovar::Resource("http://movida.example.com:3000/resource", auth)
    resource.name.should == "Resource Name"
  end
  
end
