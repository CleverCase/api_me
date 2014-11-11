require 'spec_helper'

describe 'multi-word API resource' do
  it 'succeeds creating a new object using a resource that consists of multiple words' do
    post '/api/v1/multi_word_resources', test_model: { test: true }

    expect(last_response.status).to eq(201)
    json = JSON.parse(last_response.body)

    expect(json['test_model']['created']).to eq(true)
  end
end
