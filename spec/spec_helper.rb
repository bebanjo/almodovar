require 'rubygems'
require 'webmock/rspec'
require 'lorax'
require 'almodovar'

module Helpers

  def parse_json(json)
    JSON.parse(json)
  end

  def stub_auth_request(method, url)
    stub_request(method, url).with(basic_auth: [auth.username, auth.password])
  end

  def auth_request(method, url)
    a_request(method, url).with(basic_auth: [auth.username, auth.password])
  end

  def auth
    @auth ||= Almodovar::DigestAuth.new("realm", "user", "password")
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.include WebMock::API
  config.before(:suite) do
    $default_options = Almodovar.default_options.dup
  end
  config.before(:each) do |example|
    unless example.metadata[:skip_force_basic_auth]
      Almodovar.default_options = $default_options.merge(force_basic_auth: true)
    end
  end
  config.after(:each) do
    WebMock.reset!
    Almodovar.default_options = $default_options
  end
end

module NokogiriMatchers
  RSpec::Matchers.define :have_processing_instruction do |processing_instruction|
    match do |xml_string|
      xml_string.starts_with?(processing_instruction)
    end

    failure_message do |xml_string|
      "expected to have #{processing_instruction} at the beggining of xml:\n#{xml_string}"
    end
  end

  RSpec::Matchers.define :match_xpath do |xpath|
    match do |xml_string|
      Nokogiri::XML.parse(xml_string).at_xpath(xpath) != nil
    end

    failure_message do |xml_string|
      "expected to match xpath #{xpath} in xml:\n#{xml_string}"
    end

    failure_message_when_negated do |xml_string|
      "expected to not match xpath #{xpath} in xml:\n#{xml_string}"
    end

  end

  RSpec::Matchers.define :equal_xml do |expected_xml_string|
    match do |actual_xml_string|
      @expected_doc = Nokogiri.parse(expected_xml_string)
      @actual_doc   = Nokogiri.parse(actual_xml_string)
      Lorax::Signature.new(@expected_doc.root).signature == Lorax::Signature.new(@actual_doc.root).signature
    end

    failure_message do |actual_xml_string|
      "XML documents expected to be the same:\n\nExpected:\n#{expected_xml_string}\n\nActual:\n#{actual_xml_string}"
    end

    failure_message_when_negated do |actual_xml_string|
      "XML documents expected to be different but are equal"
    end

  end

  RSpec::Matchers.define :have_text do |expected_text|
    match do |actual_xml_string|
      actual_text = Nokogiri.parse(actual_xml_string).text
      actual_text.gsub(/\s+/,' ').include? expected_text.gsub(/\s+/,' ')
    end

    failure_message do |actual_xml_string|
      "Document expected to contain \"#{expected_text}\". Actual:\n#{actual_xml_string}"
    end

    failure_message_when_negated do |actual_xml_string|
      "Document expected to not contain \"#{expected_text}\". Actual:\n#{actual_xml_string}"
    end
  end
end
