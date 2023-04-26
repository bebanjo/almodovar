require 'spec_helper'

describe "Updating resources" do

  example "Updating a resource" do
    url = "http://movida.example.com/projects/1"

    stub_auth_request(:put, url).with do |req|
      req.body == {name: "Wadus Wadus"}.to_xml(root: "project")
    end.to_return(body: <<-XML)
      <project>
        <name>Wadus Wadus</name>
        <link rel="self" href="#{url}"/>
      </project>
    XML

    project = Almodovar::Resource(url, auth)

    project.update(project: {name: "Wadus Wadus"})

    expect(project.name).to eq("Wadus Wadus")
  end

  example "Updating a document resource" do
    url = "http://movida.example.com/people/1/extra_data"

    stub_auth_request(:put, url).with do |req|
      req.body == {birthplace: "Calzada de Calatrava"}.to_xml(root: "extra-data")
    end.to_return(body: <<-XML)
      <extra-data type="document">
        <birthplace>Calzada de Calatrava</birthplace>
        <birthyear type="integer">1949</birthyear>
      </extra-data>
    XML

    extra_data = Almodovar::Resource(url, auth)
    extra_data.update(extra_data: {birthplace: "Calzada de Calatrava"})
    expect(extra_data.birthplace).to eq("Calzada de Calatrava")
  end

end