require "spec_helper"

feature "Fetching individual resources" do  

  scenario "Fetching untyped attributes" do
    stub_auth_request(:get, "http://movida.example.com/resource").to_return(:body => <<-XML)
      <resource>
        <name>Resource Name</name>
        <integer>12345</integer>
        <date>2009-01-01T10:00:00Z</date>
      </resource>
    XML
    
    resource = MovidaClient::Resource("http://movida.example.com/resource", auth)
    
    resource.name.should == "Resource Name"
    resource.integer.should == "12345"
    resource.date.should == "2009-01-01T10:00:00Z"
    
    expect { resource.wadus }.to raise_error(NoMethodError)
  end
  
  scenario "Fetching typed attributes" do
    stub_auth_request(:get, "http://movida.example.com/resource").to_return(:body => <<-XML)
      <resource>
        <integer type="integer">12345</integer>
        <date type="datetime">2009-01-01T10:00:00Z</date>
      </resource>
    XML
    
    resource = MovidaClient::Resource("http://movida.example.com/resource", auth)
    
    resource.integer.should == 12345
    resource.date.should == Time.utc(2009,1,1,10,0,0)
  end
  
end
