require 'spec_helper'

describe 'Users API' do
  it 'sends the list of users' do
    users = [
      User.create(username: 'Test'),
      User.create(username: 'Test 2')
    ]

    get '/api/v1/users'

    expect(last_response.status).to eq(200)
    json = JSON.parse(last_response.body)

    expect(json['users'].length).to eq(2)
  end

  it 'sends an individual user' do
    user = User.create(username: 'Test')

    get '/api/v1/users/' + user.id.to_s + '/'

    expect(last_response.status).to eq(200)
    json = JSON.parse(last_response.body)

    expect(json['user']['id']).to eq(user.id)
  end

  it 'creates a new user' do
    user_params = {
      username: 'Test'
    }

    post '/api/v1/users/', user: user_params

    expect(last_response.status).to eq(201)
    json = JSON.parse(last_response.body)

    expect(json['user']['username']).to eq(user_params[:username])
  end

  it 'updates an existing user' do
    user = User.create(username: 'Foo')

    expect(user.username).to eq('Foo')

    put '/api/v1/users/' + user.id.to_s + '/', user: { username: 'Bar' }

    updated_user = User.find(user.id)
    expect(last_response.status).to eq(204)
    expect(updated_user.username).to eq('Bar')
  end

  it 'destroys an existing user' do
    user = User.create(username: 'Foo')

    expect(user.id).to_not eq(nil)

    delete '/api/v1/users/' + user.id.to_s + '/'

    does_user_exist = User.where(id: user.id).exists?
    expect(last_response.status).to eq(204)
    expect(does_user_exist).to eq(false)
  end
end
