require 'spec_helper'

describe "Fetching paginated resource collections" do
  
  example "Fetch collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(:body => %q{
      <resources type='array'>
        <total-entries>4</total-entries>
        <link rel='next' href='http://movida.example.com/resources?page=2'/>
        <resource>
          <link rel='self' href='http://movida.example.com/resources/1'/>
          <name>Resource 1</name>
        </resource>
        <resource>
          <link rel='self' href='http://movida.example.com/resources/2'/>
          <name>Resource 2</name>
        </resource>
      </resources>
    })
    
    resources = Almodovar::Resource("http://movida.example.com/resources", auth)
    resources.total_entries.should == 4
    resources.size.should == 2
    resources.map(&:name).should == ["Resource 1", "Resource 2"]
    resources.next_url.should == "http://movida.example.com/resources?page=2"
  end

  example "Navigate through collection pages" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(:body => %q{
      <resources type='array'>
        <total-entries>4</total-entries>
        <link rel='next' href='http://movida.example.com/resources?page=2'/>
        <resource>
          <link rel='self' href='http://movida.example.com/resources/1'/>
          <name>Resource 1</name>
        </resource>
        <resource>
          <link rel='self' href='http://movida.example.com/resources/2'/>
          <name>Resource 2</name>
        </resource>
      </resources>
    })

    stub_auth_request(:get, "http://movida.example.com/resources?page=2").to_return(:body => %q{
      <resources type='array'>
        <total-entries>4</total-entries>
        <link rel='prev' href='http://movida.example.com/resources'/>
        <resource>
          <link rel='self' href='http://movida.example.com/resources/3'/>
          <name>Resource 3</name>
        </resource>
        <resource>
          <link rel='self' href='http://movida.example.com/resources/4'/>
          <name>Resource 4</name>
        </resource>
      </resources>
    })
    
    resources = Almodovar::Resource("http://movida.example.com/resources", auth)
    
    resources.map(&:name).should == ["Resource 1", "Resource 2"]
    resources.next_url.should == "http://movida.example.com/resources?page=2"
    resources.prev_url.should be_nil
    resources = resources.next_page

    resources.map(&:name).should == ["Resource 3", "Resource 4"]
    resources.size.should == 2
    resources.total_entries.should == 4
    resources.prev_url.should == "http://movida.example.com/resources"
    resources.next_url.should be_nil

    resources = resources.prev_page

    resources.map(&:name).should == ["Resource 1", "Resource 2"]
    resources.size.should == 2
    resources.total_entries.should == 4
  end

  example "Fetch empty collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(:body => %q{
      <resources type='array'>
        <total-entries>0</total-entries>
      </resources>
    })
    
    resources = Almodovar::Resource("http://movida.example.com/resources", auth)
    
    resources.size.should == 0
    resources.total_entries.should == 0
    resources.next_url.should be_nil
    resources.prev_url.should be_nil
    resources.next_page.should be_nil
    resources.prev_page.should be_nil
  end

end
