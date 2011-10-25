require "spec_helper"

describe "Errors should raise exceptions" do
  
  %w{400 401 403 404 405 406 422 500 502 503}.each do |code|
    example "Receiving #{code} in a GET request" do
      stub_auth_request(:get, "http://movida.example.com/resource").to_return(:body => '', :status => code.to_i)
    
      resource = Almodovar::Resource("http://movida.example.com/resource", auth)
    
      expect { resource.wadus }.to raise_error(Almodovar::HttpError, /#{code}/)
    end
    
    example "Receiving #{code} in a POST request" do
      stub_auth_request(:post, "http://movida.example.com/resources").to_return(:body => '', :status => code.to_i)
    
      resources = Almodovar::Resource("http://movida.example.com/resources", auth)
    
      expect { resources.create(:resource => {:wadus => 'wadus'}) }.to raise_error(Almodovar::HttpError, /#{code}/)
    end
    
    example "Receiving #{code} in a PUT request" do
      stub_auth_request(:put, "http://movida.example.com/resource").to_return(:body => '', :status => code.to_i)
    
      resource = Almodovar::Resource("http://movida.example.com/resource", auth)
    
      expect { resource.update(:resource => {:wadus => 'wadus'}) }.to raise_error(Almodovar::HttpError, /#{code}/)
    end
    
    example "Receiving #{code} in a DELETE request" do
      stub_auth_request(:delete, "http://movida.example.com/resource").to_return(:body => '', :status => code.to_i)
    
      resource = Almodovar::Resource("http://movida.example.com/resource", auth)
    
      expect { resource.delete }.to raise_error(Almodovar::HttpError, /#{code}/)
    end
  end

end