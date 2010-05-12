require 'spec_helper'

feature "Deleting resources" do
  
  scenario "Deleting a resource" do
    stub_auth_request(:get, "http://movida.example.com/projects/1").to_return({:body => '
      <project>
        <name>Wadus</name>
        <link rel="self" href="http://movida.example.com/projects/1"/>
      </project>
    '}, {:status => 404})
    stub_auth_request(:delete, "http://movida.example.com/projects/1").to_return(:status => 200)
    
    project = Almodovar::Resource("http://movida.example.com/projects/1", auth)
    
    project.delete
    
    # the instance should still work
    project.name.should == "Wadus"
    
    # but fetching it again not
    Almodovar::Resource(project.href, auth).should be_nil
    
    auth_request(:delete, "http://movida.example.com/projects/1").should have_been_made.once
  end
  
end