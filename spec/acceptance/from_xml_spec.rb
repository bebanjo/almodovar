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
    
    project.name.should == "My cool project"
    project.tasks.first.name.should == "Start project"
  end
  
  it "should make further HTTP calls if needed" do
    xml = %q{
      <project>
        <name>My cool project</name>
        <link rel="tasks" href="http://example.com/p/1/t"/>
      </project>
    }
    project = Almodovar::Resource.from_xml(xml, auth)
    
    project.name.should == "My cool project"
    
    stub_auth_request(:get, "http://example.com/p/1/t?expand=responsible").to_return(:body => %q{
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
    
    tasks = project.tasks(:expand => "responsible")
    
    tasks.first.name.should == "Start project"
    tasks.first.responsible.name == "El Fary"
  end
  
end
