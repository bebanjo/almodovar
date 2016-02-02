require 'spec_helper'

describe Almodovar do
  describe '.default_options' do
    before do
      Almodovar.default_options = {
        send_timeout: 0.2,
        connect_timeout: 0.2,
        receive_timeout: 0.2
      }
    end

    it 'should return set default_options' do
      expect(Almodovar.default_options[:send_timeout]).to eq(0.2)
      expect(Almodovar.default_options[:connect_timeout]).to eq(0.2)
      expect(Almodovar.default_options[:receive_timeout]).to eq(0.2)
      expect(Almodovar.default_options[:user_agent]).to eq("Almodovar/#{Almodovar::VERSION}")
    end

    it 'can overwrite default_options' do
      Almodovar.default_options = {
        send_timeout: 0.1,
        connect_timeout: 0.5,
        receive_timeout: 0.3
      }

      expect(Almodovar.default_options[:send_timeout]).to eq(0.1)
      expect(Almodovar.default_options[:connect_timeout]).to eq(0.5)
      expect(Almodovar.default_options[:receive_timeout]).to eq(0.3)
      expect(Almodovar.default_options[:user_agent]).to eq("Almodovar/#{Almodovar::VERSION}")
    end

    it "can't overwrite user agent" do
      Almodovar.default_options = {
        user_agent: "Almodovar user agent"
      }

      expect(Almodovar.default_options[:user_agent]).to eq("Almodovar/#{Almodovar::VERSION}")
    end
  end
end
