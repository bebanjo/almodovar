require 'spec_helper'

describe "Navigating linked resources" do
  example "Link to a single resource" do
    stub_auth_request(:get, "http://movida.example.com/user/1").to_return(:body => %q{
      <user>
        <link rel="related-company" href="http://movida.example.com/company/2"/>
      </user>
    })
    
    user = Almodovar::Resource("http://movida.example.com/user/1", auth)
    
    stub_auth_request(:get, "http://movida.example.com/company/2").to_return(:body => %q{
      <company>
        <age type="integer">15</age>
      </company>
    })
    
    expect(user).to respond_to(:related_company)
    
    expect(user.related_company).not_to be_nil
    expect(user.related_company.age).to eq(15)
  end
  
  example "Link to a collection of resources" do
    stub_auth_request(:get, "http://movida.example.com/company/1").to_return(:body => %q{
      <company>
        <link rel="related_users" href="http://movida.example.com/company/1/users"/>
      </company>
    })
    
    company = Almodovar::Resource("http://movida.example.com/company/1", auth)
    
    stub_auth_request(:get, "http://movida.example.com/company/1/users").to_return(:body => %q{
      <users type="array">
        <user>
          <age type="integer">46</age>
        </user>
        <user>
          <age type="integer">33</age>
        </user>
      </users>
    })
    
    expect(company).to respond_to(:related_users)
    
    expect(company.related_users.size).to eq(2)
    expect(company.related_users.first.age).to eq(46)
    expect(company.related_users.last.age).to eq(33)
  end
  
  example "Link to a collection of resources with params" do
    stub_auth_request(:get, "http://movida.example.com/company/1").to_return(:body => %q{
      <company>
        <link rel="related_users" href="http://movida.example.com/company/1/users"/>
      </company>
    })
    
    company = Almodovar::Resource("http://movida.example.com/company/1", auth)
    
    stub_auth_request(:get, "http://movida.example.com/company/1/users?min_age=23&recent=true").to_return(:body => %q{
      <users type="array">
        <user>
          <age type="integer">46</age>
        </user>
        <user>
          <age type="integer">33</age>
        </user>
      </users>
    })
    
    expect(company.related_users(:min_age => 23, :recent => true).size).to eq(2)
  end
  
  example "Expanded link to a single resource" do
    stub_auth_request(:get, "http://movida.example.com/user/1?expand=employer").to_return(:body => %q{
      <user>
        <link rel="employer" href="http://movida.example.com/company/2">
          <company>
            <age type="integer">15</age>
          </company>
        </link>
      </user>
    })
    
    user = Almodovar::Resource("http://movida.example.com/user/1", auth, :expand => :employer)
    
    expect(user.employer).not_to be_nil
    expect(user.employer.age).to eq(15)
  end
  
  example "Expanded link to a resource collection" do
    
    stub_auth_request(:get, "http://movida.example.com/company/1?expand=users,department").to_return(:body => %q{
      <company>
        <link rel="users" href="http://movida.example.com/company/1/users">
          <users type="array">
            <user>
              <link rel="department" href="http://movida.example.com/deparment/5">
                <department>
                  <name>Sales</name>
                </department>
              </link>
            </user>
            <user>
              <link rel="department" href="http://movida.example.com/deparment/6">
                <department>
                  <name>Development</name>
                </department>
              </link>
            </user>
          </users>
        </link>
      </company>
    })
    
    company = Almodovar::Resource("http://movida.example.com/company/1", auth, :expand => [:users, :department])
    
    expect(company.users.size).to eq(2)
    expect(company.users.first.department.name).to eq("Sales")
    expect(company.users.last.department.name).to eq("Development")
    
  end
  
  example "Expanded link to a resource collection using params" do
    stub_auth_request(:get, "http://movida.example.com/company/1?expand=users").to_return(:body => %q{
      <company>
        <link rel="users" href="http://movida.example.com/company/1/users">
          <users type="array">
            <user>
              <age type="integer">46</age>
            </user>
            <user>
              <age type="integer">33</age>
            </user>
          </users>
        </link>
      </company>
    })
    
    company = Almodovar::Resource("http://movida.example.com/company/1", auth, :expand => :users)
    
    stub_auth_request(:get, "http://movida.example.com/company/1/users?min_age=40").to_return(:body => %q{
      <users type="array">
        <user>
          <age type="integer">46</age>
        </user>
      </users>
    })
    
    expect(company.users(:min_age => 40).size).to eq(1)
  end

  example "Link to self" do
    stub_auth_request(:get, "http://movida.example.com/user/1").to_return(:body => %q{
      <user>
        <link rel="self" href="http://movida.example.com/user/1"/>
      </user>
    })
    
    user = Almodovar::Resource("http://movida.example.com/user/1", auth)
    
    expect(user.url).to eq("http://movida.example.com/user/1")
  end
  
  example "Using a port different than default" do
    stub_auth_request(:get, "http://movida.example.com:3000/user/1").to_return(:body => %q{
      <user>
        <link rel="related-company" href="http://movida.example.com:3000/company/2"/>
      </user>
    })
    
    user = Almodovar::Resource("http://movida.example.com:3000/user/1", auth)
    
    stub_auth_request(:get, "http://movida.example.com:3000/company/2").to_return(:body => %q{
      <company>
        <age type="integer">15</age>
      </company>
    })
    
    expect(user.related_company).not_to be_nil
    expect(user.related_company.age).to eq(15)
  end
end