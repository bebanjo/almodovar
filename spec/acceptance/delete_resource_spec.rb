require 'spec_helper'

describe "Deleting resources" do
  
  example "Deleting a resource" do
    project = Almodovar::Resource("http://movida.example.com/projects/1", auth)
    
    stub_auth_request(:delete, "http://movida.example.com/projects/1").to_return(:status => 200)
    
    project.delete
    
    auth_request(:delete, "http://movida.example.com/projects/1").should have_been_made.once
  end
  
end