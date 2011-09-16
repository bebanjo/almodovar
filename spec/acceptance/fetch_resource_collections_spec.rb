require 'spec_helper'

describe "Fetching resource collections" do
  
  example "Fetch collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(:body => <<-XML)
      <resources type='array'>
        <resource>
          <link rel='self' href='http://movida.example.com/resources/1'/>
          <name>Resource 1</name>
        </resource>
        <resource>
          <link rel='self' href='http://movida.example.com/resources/2'/>
          <name>Resource 2</name>
        </resource>
      </resources>
    XML
    
    resources = Almodovar::Resource("http://movida.example.com/resources", auth)
    
    resources.map(&:name).should == ["Resource 1", "Resource 2"]
    resources.size.should == 2
    resources.first.name.should == "Resource 1"
    resources.last.name.should  == "Resource 2"
  end
  
  example "Fetch a collection with params" do
    stub_auth_request(:get, "http://movida.example.com/resources?name=pedro").to_return(:body => <<-XML)
      <resources type='array'>
        <resource>
          <name>Pedro</name>
        </resource>
      </resources>
    XML
        
    resources = Almodovar::Resource("http://movida.example.com/resources", auth, :name => "pedro")
    
    resources.size.should == 1
    resources.first.name.should == "Pedro"
  end
  
  example "Inspecting a collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(:body => %q{
      <resources type='array'>
        <resource>
          <name>Pedro</name>
        </resource>
      </resources>
    })
    
    resources = Almodovar::Resource("http://movida.example.com/resources", auth)

    resources.inspect.should == "[#{resources.first.inspect}]"
  end
  
end