require 'rubygems'
require 'steak'
require 'webmock/rspec'
require 'lorax'

require "almodovar"


module Helpers  
  def stub_auth_request(*args)
    stub_request(*args).with(:headers => {"Authorization" => /^Digest/ })
  end
  
  def auth_request(*args)
    request(*args).with(:headers => {"Authorization" => /^Digest/ })
  end
  
  def auth
    Almodovar::DigestAuth.new("realm", "user", "password")
  end
end

Spec::Runner.configure do |config|
  config.include Helpers
  config.include WebMock
  config.before(:each) do
    stub_request(:any, //).with { |request| !request.headers.has_key?("Authorization") }.
                           to_return(
                             :status => 401, :headers => {
                               "WWW-Authenticate" => 'Digest realm="realm", qop="auth", algorithm=MD5, nonce="MTI3MDczNjM0NTpiNjQ5MDNkMzMyNDVhYWE0M2M2OWRiYmJmNDU2MjhlMg==", opaque="0b3ab90874517ff5f4ea48fe15f49f8c"'
                            })
  end
  config.after(:each) { reset_webmock }
end

module NokogiriMatchers
  Spec::Matchers.define :have_processing_instruction do |processing_instruction|
    match do |xml_string|
      xml_string.starts_with?(processing_instruction)
    end

    failure_message_for_should do |xml_string|
      "expected to have #{processing_instruction} at the beggining of xml:\n#{xml_string}"
    end
  end
  
  Spec::Matchers.define :match_xpath do |xpath|
    match do |xml_string|
      Nokogiri::XML.parse(xml_string).at_xpath(xpath).present?
    end
    
    failure_message_for_should do |xml_string|
      "expected to match xpath #{xpath} in xml:\n#{xml_string}"
    end
    
    failure_message_for_should_not do |xml_string|
      "expected to not match xpath #{xpath} in xml:\n#{xml_string}"
    end
    
  end
  
  Spec::Matchers.define :equal_xml do |expected_xml_string|
    match do |actual_xml_string|
      @expected_doc = Nokogiri.parse(expected_xml_string)
      @actual_doc   = Nokogiri.parse(actual_xml_string)
      Lorax::Signature.new(@expected_doc.root).signature == Lorax::Signature.new(@actual_doc.root).signature
    end
    
    failure_message_for_should do |actual_xml_string|
      "XML documents expected to be the same:\n\nExpected:\n#{expected_xml_string}\n\nActual:\n#{actual_xml_string}"
    end
    
    failure_message_for_should_not do |actual_xml_string|
      "XML documents expected to be different but are equal"
    end
    
  end
end