require 'spec_helper'

describe "Http Session" do

  before do
    timeout = 10
    connect_timout = 5
    user_agent = "Dummy/0.1"

    @session = Almodovar::Alternatives::HttpClient.new.tap do |session|
      session.timeout= timeout
      session.connect_timeout = connect_timout
      session.agent_name = user_agent
    end
  end

  it "provides user-agent on each request" do
    pending "This test cannot be executed until https://github.com/bblimke/webmock/issues/322 is fixed"
    stub_request(:get, "www.example.com/user-agent").with(:headers => {'User-Agent' => "Dummy/0.1"})
    @session.get("http://www.example.com/user-agent")
  end

  describe "Real HTTP calls" do

    before(:all) do
      WebMock.disable!
    end

    after(:all) do
      WebMock.enable!
    end

    it "Provides user-agent on each request" do
      server = mount_rack(env_inspector_rack, 9292)
      res = @session.get("http://localhost:9292/HTTP_USER_AGENT")
      res.body.should include "Dummy/0.1"
      server.exit
    end

    context "Digest authentication" do

      before(:all) do
        authorized_users = {"user" => "p4ssw0rd"}
        rack = with_digest_auth(env_inspector_rack, authorized_users)
        @server = mount_rack(rack, 9292)
      end

      after(:all) do
        @server.exit
      end

      it "Succeeds authentication using the right credentials" do
        @session.username = "user"
        @session.password = "p4ssw0rd"
        res = @session.get("http://localhost:9292/HTTP_USER_AGENT")
        res.status.should == 200
      end

      it "Fails authenticating using wrong credentials" do
        @session.username = "user"
        @session.password = "wrong_password"
        res = @session.get("http://localhost:9292/HTTP_USER_AGENT")
        res.status.should == 401
      end
    end
  end
end