require 'spec_helper'

feature "Creating new resources" do
  
  scenario "Creating a resource in a collection" do
    stub_auth_request(:get, "http://movida.example.com/projects").to_return(:body => %q{
      <projects type='array'></projects>
    })  
    
    stub_auth_request(:post, "http://movida.example.com/projects").with do |req|
      req.body == {:name => "Wadus"}.to_xml(:root => "project")
    end.to_return(:body => %q{
      <project>
        <name>Wadus</name>
        <link rel="self" href="http://movida.example.com/projects/1"/>
      </project>
    })
    
    stub_auth_request(:get, "http://movida.example.com/projects/1").to_return(:body => %q{
      <project>
        <name>Wadus</name>
        <link rel="self" href="http://movida.example.com/projects/1"/>
      </project>
    })
    
    projects = Almodovar::Resource("http://movida.example.com/projects", auth)
    
    project = projects.create(:name => "Wadus")
    
    project.should be_a(Almodovar::Resource)
    project.name.should == "Wadus"
    project.should == Almodovar::Resource(project.href, auth)    
  end
  
  scenario "Creating a resource expanding links" do
    stub_auth_request(:get, "http://movida.example.com/projects?expand=tasks").to_return(:body => %q{
      <projects type='array'></projects>
    })  
    
    stub_auth_request(:post, "http://movida.example.com/projects").with do |req|
      req.body == {:name => "Wadus", :template => "Basic"}.to_xml(:root => "project")
    end.to_return(:body => %q{
      <project>
        <name>Wadus</name>
        <template>Basic</template>
        <link rel="self" href="http://movida.example.com/projects/1"/>
        <link rel="tasks" href="http://movida.example.com/projects/1/tasks">
          <tasks type="array">
            <task>
              <name>Starting Meeting</name>
            </task>
          </tasks>
        </link>
      </project>
    })
    
    projects = Almodovar::Resource("http://movida.example.com/projects", auth, :expand => :tasks)    
    project = projects.create(:name => "Wadus", :template => "Basic")
    
    project.should be_a(Almodovar::Resource)
    project.name.should == "Wadus"
    project.tasks.size.should == 1
    project.tasks.first.name.should == "Starting Meeting"
  end
  
end