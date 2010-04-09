require 'spec_helper'

feature "Fetching resource collections" do
  
  scenario "Fetch collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(:body => <<-XML)
      <resources type='array'>
        <resource>
          <name>Resource 1</name>
        </resource>
        <resource>
          <name>Resource 2</name>
        </resource>
      </resources>
    XML
    
    resources = MovidaClient::Resource("http://movida.example.com/resources", auth)

    resources.should have(2).resources
    resources.should be_a(Array)
    resources.first.name.should == "Resource 1"
    resources.last.name.should  == "Resource 2"
  end
  
  scenario "Fetch a collection with params" do
    stub_auth_request(:get, "http://movida.example.com/resources?name=pedro").to_return(:body => <<-XML)
      <resources type='array'>
        <resource>
          <name>Pedro</name>
        </resource>
      </resources>
    XML
        
    resources = MovidaClient::Resource("http://movida.example.com/resources", auth, :name => "pedro")
    
    resources.should have(1).resource
    resources.should be_a(Array)
    resources.first.name.should == "Pedro"
  end
end