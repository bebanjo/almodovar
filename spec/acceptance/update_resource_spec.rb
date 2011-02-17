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
    
    project.update(:project => {:name => "Wadus Wadus"})
    
    project.name.should == "Wadus Wadus"
  end
  
  scenario "Updating a document resource" do
    stub_auth_request(:put, "http://movida.example.com/people/1/extra_data").with do |req|
      req.body == {:birthplace => "Calzada de Calatrava"}.to_xml(:root => "extra-data")
    end.to_return(:body => <<-XML)
      <extra-data type="document">
        <birthplace>Calzada de Calatrava</birthplace>
        <birthyear type="integer">1949</birthyear>
      </extra-data>
    XML
    
    extra_data = Almodovar::Resource("http://movida.example.com/people/1/extra_data", auth)
    extra_data.update(:extra_data => {:birthplace => "Calzada de Calatrava"})
    extra_data.birthplace.should == "Calzada de Calatrava"
  end
  
end