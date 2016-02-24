require 'spec_helper'

describe "Timeout" do
  context "raise Almodovar::TimeoutError exception" do
    [[HTTPClient::TimeoutError, Almodovar::TimeoutError],
     [HTTPClient::SendTimeoutError, Almodovar::SendTimeoutError],
     [HTTPClient::ReceiveTimeoutError, Almodovar::ReceiveTimeoutError],
     [HTTPClient::ConnectTimeoutError, Almodovar::ConnectTimeoutError]].each do |httpclient_exception, almodovar_exception|
      it "for get" do
        project = Almodovar::Resource("http://movida.example.com/projects/1", auth)

        stub_auth_request(:get, "http://movida.example.com/projects/1").to_raise(httpclient_exception)

        expect {
          project.name
        }.to raise_error(almodovar_exception)
      end

      it "for create" do
        projects = Almodovar::Resource("http://movida.example.com/projects", auth)

        stub_auth_request(:post, "http://movida.example.com/projects").to_raise(httpclient_exception)

        expect {
          projects.create(project: { name: "Wadus"})
        }.to raise_error(almodovar_exception)
      end

      it "for put" do
        projects = Almodovar::Resource("http://movida.example.com/projects/1", auth)

        stub_auth_request(:put, "http://movida.example.com/projects/1").to_raise(httpclient_exception)

        expect {
          projects.update(project: { name: "Wadus"})
        }.to raise_error(almodovar_exception)
      end

      it "for delete" do
        projects = Almodovar::Resource("http://movida.example.com/projects/1", auth)

        stub_auth_request(:delete, "http://movida.example.com/projects/1").to_raise(httpclient_exception)

        expect {
          projects.delete
        }.to raise_error(almodovar_exception)
      end
    end
  end
end
