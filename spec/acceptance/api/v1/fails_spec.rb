describe 'fails API', type: :api do
  it 'fails in the before action' do
    get '/api/v1/fails'

    expect(last_response.status).to eq(404)

    expect(json['status']).to eq('failed')
  end
end
