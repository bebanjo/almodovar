require 'spec_helper'

describe Almodovar::UnprocessableEntityError do
  describe '#errors?' do
    it 'returns true if there is any error message' do
      error = unprocessable_entity_error(double_response(''))
      expect(error).to receive(:error_messages).and_return(['wadus'])

      expect(error.errors?).to eq true
    end

    it 'returns false if there is no error messages' do
      error = unprocessable_entity_error(double_response(''))
      expect(error).to receive(:error_messages).and_return([])

      expect(error.errors?).to eq false
    end
  end

  describe '#error_messages' do
    it 'returns error messages for different schemes' do
      body = %q{
        <errors>
          <error>Name is taken</error>
        </errors>
      }
      error = unprocessable_entity_error(double_response(body))
      expect(error.error_messages).to eq(['Name is taken'])


      body = %q{
        <errors>
          <error>Name is taken</error>
          <error>External ID is required</error>
        </errors>
      }
      error = unprocessable_entity_error(double_response(body))
      expect(error.error_messages).to eq(['Name is taken', 'External ID is required'])

      body = %q{
        <error>
          <message>per_page maximum value is 200</message>
        </error>
      }
      error = unprocessable_entity_error(double_response(body))
      expect(error.error_messages).to eq(['per_page maximum value is 200'])
    end

    it 'returns an empty array on empty response bodies' do
      error = unprocessable_entity_error(double_response(''))
      expect(error.error_messages).to eq([])

      error = unprocessable_entity_error(double_response(nil))
      expect(error.error_messages).to eq([])
    end

    it 'returns an empty array on json response bodies (it\'s not supported from the moment)' do
      error = unprocessable_entity_error(double_response('{"wadus": "foo"}'))
      expect(error.error_messages).to eq([])
    end
  end

  def double_response(body)
    double(:response, body: body, status: nil)
  end

  def unprocessable_entity_error(response)
    Almodovar::UnprocessableEntityError.new(response, 'http://example.com/api')
  end
end
