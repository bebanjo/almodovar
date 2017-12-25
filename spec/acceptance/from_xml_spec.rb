require "spec_helper"

describe "Instantiate resources from xml" do
  
  it "should instantiate the resource without HTTP calls" do
    xml = %q{
      <project>
        <name>My cool project</name>
        <link rel="tasks">
          <tasks type="array">
            <task>
              <name>Start project</name>
            </task>
          </tasks>
        </link>
      </project>
    }
    project = Almodovar::Resource.from_xml(xml)
    
    expect(project.name).to eq("My cool project")
    expect(project.tasks.first.name).to eq("Start project")
  end
  
  it "should make further HTTP calls if needed" do
    xml = %q{
      <project>
        <name>My cool project</name>
        <link rel="tasks" href="http://example.com/p/1/t"/>
      </project>
    }
    project = Almodovar::Resource.from_xml(xml, auth)
    
    expect(project.name).to eq("My cool project")
    
    stub_auth_request(:get, "http://example.com/p/1/t?expand=responsible").to_return(body: %q{
      <tasks type="array">
        <task>
          <name>Start project</name>
          <link rel="responsible">
            <user>
              <name>El Fary</name>
            </user>
          </link>
        </task>
      </tasks>      
    })
    
    tasks = project.tasks(expand: "responsible")
    
    expect(tasks.first.name).to eq("Start project")
    tasks.first.responsible.name == "El Fary"
  end
  
end
