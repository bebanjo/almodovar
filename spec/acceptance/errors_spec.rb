require "spec_helper"

describe "Errors should raise exceptions" do

  let(:resource_url)  { "http://movida.example.com/resource" }
  let(:resources_url) { "http://movida.example.com/resources" }

  %w{400 401 403 404 405 406 422 500 502 503}.each do |code|
    example "Receiving #{code} in a GET request" do
      stub_auth_request(:get, resource_url).to_return(:body => '<error>more info</error>', :status => code.to_i)

      resource = Almodovar::Resource(resource_url, auth)

      expect { resource.wadus }.to raise_error{ |error|
        error.should be_a(Almodovar::HttpError)
        error.message.should == error_message(code, resource_url)
        error.response_body.should == '<error>more info</error>'
      }
    end

    example "Receiving #{code} in a POST request" do
      stub_auth_request(:post, resources_url).to_return(:body => '<error>more info</error>', :status => code.to_i)

      resources = Almodovar::Resource(resources_url, auth)

      expect { resources.create(:resource => {:wadus => 'wadus'}) }.to raise_error{ |error|
        error.should be_a(Almodovar::HttpError)
        error.message.should == error_message(code, resources_url)
        error.response_body.should == '<error>more info</error>'
      }
    end

    example "Receiving #{code} in a PUT request" do
      stub_auth_request(:put, resource_url).to_return(:body => '<error>more info</error>', :status => code.to_i)

      resource = Almodovar::Resource(resource_url, auth)

      expect { resource.update(:resource => {:wadus => 'wadus'}) }.to raise_error{ |error|
        error.should be_a(Almodovar::HttpError)
        error.message.should == error_message(code, resource_url)
        error.response_body.should == '<error>more info</error>'
      }
    end

    example "Receiving #{code} in a DELETE request" do
      stub_auth_request(:delete, resource_url).to_return(:body => '<error>more info</error>', :status => code.to_i)

      resource = Almodovar::Resource(resource_url, auth)

      expect { resource.delete }.to raise_error{ |error|
        error.should be_a(Almodovar::HttpError)
        error.message.should == error_message(code, resource_url)
        error.response_body.should == '<error>more info</error>'
      }
    end
  end

  private

  def error_message(code, url)
    "Status code #{code} on resource #{url}"
  end
end
