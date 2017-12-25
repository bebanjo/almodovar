require 'spec_helper'

describe "Fetching resource collections" do

  example "Fetch collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(body: %q{
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
    })

    resources = Almodovar::Resource("http://movida.example.com/resources", auth)

    expect(resources.map(&:name)).to eq(["Resource 1", "Resource 2"])
    expect(resources.size).to eq(2)
    expect(resources.first.name).to eq("Resource 1")
    expect(resources.last.name).to  eq("Resource 2")
  end

  example "Fetch a collection with params" do
    stub_auth_request(:get, "http://movida.example.com/resources?name=Jon%20Snow").to_return(body: %q{
      <resources type='array'>
        <resource>
          <name>Jon Snow</name>
        </resource>
      </resources>
    })

    resources = Almodovar::Resource("http://movida.example.com/resources", auth, name: "Jon Snow")

    expect(resources.size).to eq(1)
    expect(resources.first.name).to eq("Jon Snow")
  end

  example "Fetch a collection with params unescaped in the url" do
    stub_auth_request(:get, "http://movida.example.com/resources?name=Jon%20Snow").to_return(body: %q{
      <resources type='array'>
        <resource>
          <name>Jon Snow</name>
        </resource>
      </resources>
    })

    resources = Almodovar::Resource("http://movida.example.com/resources?name=Jon Snow", auth)

    expect(resources.size).to eq(1)
    expect(resources.first.name).to eq("Jon Snow")
  end

  example "Fetch a collection with params escaped in the url" do
    stub_auth_request(:get, "http://movida.example.com/resources?name=Jon%20Snow").to_return(body: %q{
      <resources type='array'>
        <resource>
          <name>Jon Snow</name>
        </resource>
      </resources>
    })

    resources = Almodovar::Resource("http://movida.example.com/resources?name=Jon%20Snow", auth)

    expect(resources.size).to eq(1)
    expect(resources.first.name).to eq("Jon Snow")
  end

  example "Inspecting a collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(body: %q{
      <resources type='array'>
        <resource>
          <name>Pedro</name>
        </resource>
      </resources>
    })

    resources = Almodovar::Resource("http://movida.example.com/resources", auth)

    expect(resources.inspect).to eq("[#{resources.first.inspect}]")
  end

  example "Selecting elements from a collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(body: %q{
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
    })

    resources = Almodovar::Resource("http://movida.example.com/resources", auth)
    expect(resources.size).to eq(2)

    selected = resources.select {|r| r.name == "Resource 1"}
    expect(selected.size).to eq(1)
    expect(selected.first.name).to eq("Resource 1")
  end

  example "Pagination methods on non paginated collection" do
    stub_auth_request(:get, "http://movida.example.com/resources").to_return(body: %q{
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
    })

    resources = Almodovar::Resource("http://movida.example.com/resources", auth)
    expect(resources.total_entries).to eq(2)
    expect(resources.size).to eq(2)
    expect(resources.next_url).to be_nil
    expect(resources.prev_url).to be_nil
  end

end
