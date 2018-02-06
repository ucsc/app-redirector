require_relative 'spec_helper'

describe 'Redirector' do

  it 'should display pretty 404 errors' do
    get '/404'
    last_response.status.must_equal 404
    last_response.body.must_include "Redirect not configured"
  end

end