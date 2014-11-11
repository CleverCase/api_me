require 'spec_helper'

describe 'Users API' do
  it 'sends the list of posts using the default filter' do
    posts = [
      Post.create(name: 'test'),
      Post.create(name: 'test 2')
    ]

    get '/api/v1/posts'

    expect(last_response.status).to eq(200)
    json = JSON.parse(last_response.body)

    expect(json['posts'].length).to eq(posts.count)
  end

  it 'sends posts filtered by ids' do
    all_posts = [
      Post.create(name: 'test'),
      Post.create(name: 'test 2'),
      Post.create(name: 'test 3')
    ]

    filtered_posts = [all_posts[0], all_posts[2]]

    get '/api/v1/posts?ids%5B%5D=' + filtered_posts[0].id.to_s +
      '&ids%5B%5D=' + filtered_posts[1].id.to_s

    expect(last_response.status).to eq(200)
    json = JSON.parse(last_response.body)

    expect(json['posts'].length).to eq(filtered_posts.count)
  end
end
