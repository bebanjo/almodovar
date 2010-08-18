require "spec_helper"

feature "Fetching individual resources" do  

  scenario "Fetching untyped attributes" do
    stub_auth_request(:get, "http://movida.example.com/resource").to_return(:body => <<-XML)
      <resource>
        <name>Resource Name</name>
        <res_id>12345</res_id>
        <creation-date>2009-01-01T10:00:00Z</creation-date>
      </resource>
    XML
    
    resource = Almodovar::Resource("http://movida.example.com/resource", auth)
    resource.name.should == "Resource Name"
    resource.res_id.should == "12345"
    resource.creation_date.should == "2009-01-01T10:00:00Z"
    
    expect { resource.wadus }.to raise_error(NoMethodError)
  end
  
  scenario "Fetching typed attributes" do
    stub_auth_request(:get, "http://movida.example.com/resource").to_return(:body => <<-XML)
      <resource>
        <id type="integer">12345</id>
        <date type="datetime">2009-01-01T10:00:00Z</date>
        <type>wadus</type>
        <responsibles type="array">
          <responsible>
            <name>porras</name>
          </responsible>
          <responsible>
            <name>cavalle</name>
          </responsible>
        </responsibles>
      </resource>
    XML
    
    resource = Almodovar::Resource("http://movida.example.com/resource", auth)
    
    resource.id.should == 12345
    resource.date.should == Time.utc(2009,1,1,10,0,0)
    resource.type.should == "wadus"
    resource.responsibles.map(&:name).should == ["porras", "cavalle"]
  end
  
  scenario "Inspecting a resource" do
    xml = %q{
      <resource>
        <id type="integer">12345</id>
        <date type="datetime">2009-01-01T10:00:00Z</date>
      </resource>      
    }
    stub_auth_request(:get, "http://movida.example.com/resource").to_return(:body => xml)
    
    resource = Almodovar::Resource("http://movida.example.com/resource", auth)

    Nokogiri.parse(resource.inspect).to_xml.should == Nokogiri.parse(xml).to_xml
  end
  
end
