require 'spec_helper'

describe "Creating new resources" do

  example "Creating a resource in a collection" do

    projects = Almodovar::Resource("http://movida.example.com/projects", auth)

    stub_auth_request(:post, "http://movida.example.com/projects").with do |req|
      # we parse because comparing strings is too fragile because of order changing, different indentations, etc.
      # we're expecting something very close to this:
      # <project>
      #   <name>Wadus</name>
      # </project>
      Nokogiri::XML.parse(req.body).at_xpath("/project/name").text == "Wadus"
    end.to_return(body: %q{
      <project>
        <name>Wadus</name>
        <link rel="self" href="http://movida.example.com/projects/1"/>
      </project>
    })

    project = projects.create(project: {name: "Wadus"})

    expect(project).to be_a(Almodovar::Resource)
    expect(project.name).to eq("Wadus")

    stub_auth_request(:get, "http://movida.example.com/projects/1").to_return(body: %q{
      <project>
        <name>Wadus</name>
        <link rel="self" href="http://movida.example.com/projects/1"/>
      </project>
    })

    expect(project.name).to eq(Almodovar::Resource(project.url, auth).name)
  end

  example "Creating a resource expanding links" do
    stub_auth_request(:post, "http://movida.example.com/projects?expand=tasks").with do |req|
      # <project>
      #   <name>Wadus</name>
      #   <template>Basic</template>
      # </project>
      xml = Nokogiri::XML.parse(req.body)
      xml.at_xpath("/project/name").text == "Wadus" &&
      xml.at_xpath("/project/template").text == "Basic"
    end.to_return(body: %q{
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

    projects = Almodovar::Resource("http://movida.example.com/projects", auth, expand: :tasks)
    project = projects.create(project: {name: "Wadus", template: "Basic"})

    expect(project).to be_a(Almodovar::Resource)
    expect(project.name).to eq("Wadus")
    expect(project.tasks.size).to eq(1)
    expect(project.tasks.first.name).to eq("Starting Meeting")
  end

  example "Creating linking to existing resources" do
    projects = Almodovar::Resource("http://movida.example.com/projects", auth)

    stub_auth_request(:post, "http://movida.example.com/projects").with do |req|
      # <project>
      #   <link rel="owner" href="http://example.com/people/luismi"/>
      # </project>
      xml = Nokogiri::XML.parse(req.body)
      xml.at_xpath("/project/link[@rel='owner'][@href='http://example.com/people/luismi'][not(node())]")
    end.to_return(body: %q{
      <project>
        <link rel="self" href="http://movida.example.com/projects/1"/>
        <link rel="owner" href="http://example.com/people/luismi"/>
      </project>
    })

    project = projects.create(project: {owner: Almodovar::Resource("http://example.com/people/luismi")})

    expect(project).to be_a(Almodovar::Resource)
    expect(project.owner.url).to eq("http://example.com/people/luismi")
  end

  example "Creating single nested resources" do
    projects = Almodovar::Resource("http://movida.example.com/projects", auth, expand: :tasks)

    stub_auth_request(:post, "http://movida.example.com/projects?expand=tasks").with do |req|
      # <project>
      #   <name>Wadus</name>
      #   <link rel="timeline">
      #     <timeline>
      #       <name>Start project</name>
      #     </timeline>
      #   </link>
      # </project>
      xml = Nokogiri::XML.parse(req.body)
      xml.at_xpath("/project/name").text == "Wadus" &&
      xml.at_xpath("/project/link[@rel='timeline']/timeline/name").text == "Start project" &&
      xml.at_xpath("/project/link[@rel='timeline']/timeline/link[@rel='wadus']/wadus") != nil
    end.to_return(body: %q{
      <project>
        <name>Wadus</name>
        <link rel="self" href="http://movida.example.com/projects/1"/>
        <link rel="timeline" href="http://movida.example.com/projects/1/timeline">
          <timeline>
            <name>Start project</name>
          </timeline>
        </link>
      </project>
    })

    project = projects.create(project: {name: "Wadus", timeline: {name: "Start project", wadus: {}}})

    expect(project).to be_a(Almodovar::Resource)
    expect(project.name).to eq("Wadus")
    expect(project.timeline.name).to eq("Start project")
  end

  example "Creating multiple nested resources" do
    projects = Almodovar::Resource("http://movida.example.com/projects", auth, expand: :tasks)

    stub_auth_request(:post, "http://movida.example.com/projects?expand=tasks").with do |req|
      # <project>
      #   <link rel="tasks">
      #     <tasks type="array">
      #       <task>
      #         <name>Start project</name>
      #       </task>
      #     </tasks>
      #   </link>
      # </project>
      xml = Nokogiri::XML.parse(req.body)
      xml.at_xpath("/project/link[@rel='tasks']/tasks[@type='array']/task/name").text == "Start project"
    end.to_return(body: %q{
      <project>
        <link rel="tasks" href="http://movida.example.com/projects/1/tasks">
          <tasks type="array">
            <task>
              <name>Start project</name>
            </task>
          </tasks>
        </link>
      </project>
    })

    project = projects.create(project: {tasks: [{name: "Start project"}]})

    expect(project).to be_a(Almodovar::Resource)
    expect(project.tasks.first.name).to eq("Start project")
  end

  example "Creating batched resources" do
    requirements = Almodovar::Resource("http://movida.example.com/api/requirements", auth)
    granted_requirements = Almodovar::Resource("http://movida.example.com/api/blackouts/13/granted_requirements", auth)

    stub_auth_request(:get, "http://movida.example.com/api/requirements").to_return(body: %q{
      <?xml version="1.0" encoding="UTF-8"?>
      <requirements type="array">
        <requirement>
          <id type="integer">5214</id>
          <category>Owner</category>
          <value>Virgin Media Ireland</value>
          <link rel="self" href="http://movida.example.com/api/requirements/5214"/>
        </requirement>
        <requirement>
          <id type="integer">5149</id>
          <category>Owner</category>
          <value>YouTube (CMS)</value>
          <link rel="self" href="http://movida.example.com/api/requirements/5149"/>
        </requirement>
      </requirements>
    })

    stub_auth_request(:post, "http://movida.example.com/api/blackouts/13/granted_requirements").with do |req|
      # <granted-requirements type="array">
      #   <granted-requirement>
      #     <link rel="requirement" href="http://movida.example.com/api/requirements/5214"/>
      #   </granted-requirement>
      #   <granted-requirement>
      #     <link rel="requirement" href="http://movida.example.com/api/requirements/5149"/>
      #   </granted-requirement>
      # </granted-requirements>
      xml = Nokogiri::XML.parse(req.body)
      xml.at_xpath("/granted-requirements[@type='array']/granted-requirement/link[@rel='requirement'][@href='http://movida.example.com/api/requirements/5214'][not(node())]")
      xml.at_xpath("/granted-requirements[@type='array']/granted-requirement[2]/link[@rel='requirement'][@href='http://movida.example.com/api/requirements/5149'][not(node())]")
    end.to_return(body: %q{
      <?xml version="1.0" encoding="UTF-8"?>
      <granted-requirements type="array">
        <granted-requirement>
          <id type="integer">10</id>
          <link rel="self" href="http://movida.example.com/api/granted_requirements/10"/>
          <link rel="requirement" href="http://movida.example.com/api/requirements/5214"/>
        </granted-requirement>
        <granted-requirement>
          <id type="integer">11</id>
          <link rel="self" href="http://movida.example.com/api/granted_requirements/11"/>
          <link rel="requirement" href="http://movida.example.com/api/requirements/5149"/>
        </granted-requirement>
      </granted-requirements>
    })

    granted_requirements = granted_requirements.create(granted_requirements:
      requirements.map { |r| {requirement: r} }
    )

    expect(granted_requirements).to be_a(Almodovar::Resource)
    expect(granted_requirements.first.id).to eq(10)
  end

  example "Creating a resource raise UnprocessableEntityError" do
    projects = Almodovar::Resource("http://movida.example.com/projects", auth)

    stub_auth_request(:post, "http://movida.example.com/projects").with do |req|
      # we parse because comparing strings is too fragile because of order changing, different indentations, etc.
      # we're expecting something very close to this:
      # <project>
      #   <name>Wadus</name>
      # </project>
      Nokogiri::XML.parse(req.body).at_xpath("/project/name").text == "Wadus"
    end.to_return(body: %q{
      <errors>
        <error>Name is taken</error>
      </errors>
    }, status: 422)

    expect do
      begin
        projects.create(project: {name: "Wadus"})
      rescue Almodovar::UnprocessableEntityError => exception
        expect(exception.errors?).to eq true
        expect(exception.error_messages).to eq ["Name is taken"]
        raise exception
      end
    end.to raise_error(Almodovar::UnprocessableEntityError)
  end

end
