require 'spec_helper'

describe Almodovar::TooManyRequestsError do
  describe '#ratelimit_reset' do
    it 'returns the value of the `ratelimit-reset` header' do
      headers = {
        "ratelimit-reset"=>"251",
        "status"=>"429 Too Many Requests"
      }
      error = too_many_requests_error(double_response(headers))

      expect(error.ratelimit_reset).to eq '251'
    end
  end

  def double_response(headers)
    double(:response, body: "", headers: headers, status: nil)
  end

  def too_many_requests_error(response)
    Almodovar::TooManyRequestsError.new(response, 'http://example.com/api')
  end
end
