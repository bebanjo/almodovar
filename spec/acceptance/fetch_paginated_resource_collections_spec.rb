require 'spec_helper'

describe "Fetching paginated resource collections" do
  
  example "Fetch collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(body: %q{
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
    expect(resources.total_entries).to eq(4)
    expect(resources.size).to eq(2)
    expect(resources.map(&:name)).to eq(["Resource 1", "Resource 2"])
    expect(resources.next_url).to eq("http://movida.example.com/resources?page=2")
  end

  example "Navigate through collection pages" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(body: %q{
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

    stub_auth_request(:get, "http://movida.example.com/resources?page=2").to_return(body: %q{
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
    
    expect(resources.map(&:name)).to eq(["Resource 1", "Resource 2"])
    expect(resources.next_url).to eq("http://movida.example.com/resources?page=2")
    expect(resources.prev_url).to be_nil
    resources = resources.next_page

    expect(resources.map(&:name)).to eq(["Resource 3", "Resource 4"])
    expect(resources.size).to eq(2)
    expect(resources.total_entries).to eq(4)
    expect(resources.prev_url).to eq("http://movida.example.com/resources")
    expect(resources.next_url).to be_nil

    resources = resources.prev_page

    expect(resources.map(&:name)).to eq(["Resource 1", "Resource 2"])
    expect(resources.size).to eq(2)
    expect(resources.total_entries).to eq(4)
  end

  example "Fetch empty collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(body: %q{
      <resources type='array'>
        <total-entries>0</total-entries>
      </resources>
    })
    
    resources = Almodovar::Resource("http://movida.example.com/resources", auth)
    
    expect(resources.size).to eq(0)
    expect(resources.total_entries).to eq(0)
    expect(resources.next_url).to be_nil
    expect(resources.prev_url).to be_nil
    expect(resources.next_page).to be_nil
    expect(resources.prev_page).to be_nil
  end

end
