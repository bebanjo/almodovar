require 'spec_helper'

feature "Navigating linked resources" do
  scenario "Link to a single resource" do
    stub_auth_request(:get, "http://movida.example.com/user/1").to_return(:body => <<-XML)
      <user>
        <link rel="company" href="http://movida.example.com/company/2"/>
      </user>
    XML
    
    user = MovidaClient::Resource("http://movida.example.com/user/1", auth)
    
    stub_auth_request(:get, "http://movida.example.com/company/2").to_return(:body => <<-XML)
      <company>
        <age type="integer">15</age>
      </company>
    XML
    
    user.company.should_not be_nil
    user.company.age.should == 15
  end
  
  scenario "Link to a collection of resources" do
    stub_auth_request(:get, "http://movida.example.com/company/1").to_return(:body => <<-XML)
      <company>
        <link rel="users" href="http://movida.example.com/company/1/users"/>
      </company>
    XML
    
    company = MovidaClient::Resource("http://movida.example.com/company/1", auth)
    
    stub_auth_request(:get, "http://movida.example.com/company/1/users").to_return(:body => <<-XML)
      <users type="array">
        <user>
          <age type="integer">46</age>
        </user>
        <user>
          <age type="integer">33</age>
        </user>
      </users>
    XML
    
    company.users.size.should == 2
    company.users.first.age.should == 46
    company.users.last.age.should == 33
  end
  
  scenario "Expanded link to a single resource" do
    stub_auth_request(:get, "http://movida.example.com/user/1?expand=company").to_return(:body => <<-XML)
      <user>
        <link rel="company" href="http://movida.example.com/company/2">
          <company>
            <age type="integer">15</age>
          </company>
        </link>
      </user>
    XML
    
    user = MovidaClient::Resource("http://movida.example.com/user/1", auth, :expand => :company)
    
    user.company.should_not be_nil
    user.company.age.should == 15
  end
  
  scenario "Expanded link to a resource collection" do
    
    stub_auth_request(:get, "http://movida.example.com/company/1?expand=users,department").to_return(:body => <<-XML)
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
    XML
    
    company = MovidaClient::Resource("http://movida.example.com/company/1", auth, :expand => [:users, :department])
    
    company.users.size.should == 2
    company.users.first.department.name.should == "Sales"
    company.users.last.department.name.should == "Development"
    
  end
end