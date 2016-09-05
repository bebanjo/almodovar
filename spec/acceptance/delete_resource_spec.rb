require 'spec_helper'

describe "Deleting resources" do
  
  example "Deleting a resource" do
    project = Almodovar::Resource("http://movida.example.com/projects/1", auth)
    
    stub_auth_request(:delete, "http://movida.example.com/projects/1").to_return(:status => 200)
    
    project.delete
    
    auth_request(:delete, "http://movida.example.com/projects/1").should have_been_made.once
  end

  example "Deleting a resource raise UnprocessableEntityError" do
    project = Almodovar::Resource("http://movida.example.com/projects/1", auth)

    stub_auth_request(:delete, "http://movida.example.com/projects/1").to_return(:body => %q{
      <errors>
        <error>Should delete existing tasks first</error>
      </errors>
    }, status: 422)

    expect do
      begin
        project.delete
      rescue Almodovar::UnprocessableEntityError => exception
        expect(exception.errors?).to eq true
        expect(exception.error_messages).to eq ["Should delete existing tasks first"]
        raise exception
      end
    end.to raise_error(Almodovar::UnprocessableEntityError)
  end
end
