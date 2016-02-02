require 'spec_helper'

describe "Timeout" do
  context "raise Almodovar::HttpClient::TimeoutError exception" do
    it "for get" do
      project = Almodovar::Resource("http://movida.example.com/projects/1", auth)

      stub_auth_request(:get, "http://movida.example.com/projects/1").to_timeout

      expect {
        project.name
      }.to raise_error(Almodovar::TimeoutError)
    end

    it "for create" do
      projects = Almodovar::Resource("http://movida.example.com/projects", auth)

      stub_auth_request(:post, "http://movida.example.com/projects").to_timeout

      expect {
        projects.create(project: { name: "Wadus"})
      }.to raise_error(Almodovar::TimeoutError)
    end

    it "for put" do
      projects = Almodovar::Resource("http://movida.example.com/projects/1", auth)

      stub_auth_request(:put, "http://movida.example.com/projects/1").to_timeout

      expect {
        projects.update(project: { name: "Wadus"})
      }.to raise_error(Almodovar::TimeoutError)
    end

    it "for delete" do
      projects = Almodovar::Resource("http://movida.example.com/projects/1", auth)

      stub_auth_request(:delete, "http://movida.example.com/projects/1").to_timeout

      expect {
        projects.delete
      }.to raise_error(Almodovar::TimeoutError)
    end
  end
end
