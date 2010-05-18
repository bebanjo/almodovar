require 'spec_helper'

feature "Updating resources" do
  
  scenario "Updating a resource" do
    stub_auth_request(:put, "http://movida.example.com/projects/1").with do |req|
      req.body == {:name => "Wadus Wadus"}.to_xml(:root => "project")
    end.to_return(:body => <<-XML)
      <project>
        <name>Wadus Wadus</name>
        <link rel="self" href="http://movida.example.com/projects/1"/>
      </project>
    XML
    
    project = Almodovar::Resource("http://movida.example.com/projects/1", auth)
    
    project.update(:name => "Wadus Wadus")
    
    project.name.should == "Wadus Wadus"
  end
  
end