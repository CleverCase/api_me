require 'spec_helper'

describe 'fails API' do
  it 'fails in the before action' do
    get '/api/v1/fails'

    expect(last_response.status).to eq(404)
    json = JSON.parse(last_response.body)

    expect(json['status']).to eq("failed")
  end
end
