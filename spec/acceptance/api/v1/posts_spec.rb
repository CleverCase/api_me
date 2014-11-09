require 'spec_helper'

describe 'Users API' do
  it 'sends the list of posts using the default filter' do
    posts = [
      Post.create(name: "test"),
      Post.create(name: "test 2")
    ]

    get '/api/v1/posts'

    expect(last_response.status).to eq(200)
    json = JSON.parse(last_response.body)

    expect(json['posts'].length).to eq(2)
  end

  it 'sends posts filtered by ids' do
    posts = [
      Post.create(name: "test"),
      Post.create(name: "test 2"),
      Post.create(name: "test 3")
    ]

    get '/api/v1/posts?ids%5B%5D=' + posts[0].id.to_s +
        '&ids%5B%5D=' + posts[2].id.to_s

    expect(last_response.status).to eq(200)
    json = JSON.parse(last_response.body)

    expect(json['posts'].length).to eq(2)
  end
end
