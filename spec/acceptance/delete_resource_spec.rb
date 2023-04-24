require 'spec_helper'

describe "Deleting resources" do
  example "Deleting a resource" do
    url = "http://movida.example.com/projects/1"

    project = Almodovar::Resource(url, auth)
    
    stub_auth_request(:delete, url).to_return(status: 200)
    
    project.delete
    
    expect(auth_request(:delete, url)).to have_been_made.once
  end

  example "Deleting a resource with query params" do
    url = "http://movida.example.com/projects/1"

    project = Almodovar::Resource(url, auth)

    stub_auth_request(:delete, url).with({
      query: {
        param1: 1,
        param2: 2,
      }
    }).to_return(status: 200)

    project.delete({
      param1: 1,
      param2: 2,
    })

    expect(auth_request(:delete, url + "?param1=1&param2=2")).to have_been_made.once
  end

  example "Deleting a resource raise UnprocessableEntityError" do
    url = "http://movida.example.com/projects/1"

    project = Almodovar::Resource(url, auth)

    stub_auth_request(:delete, url).to_return(body: %q{
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
