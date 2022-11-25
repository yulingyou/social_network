require 'post_repository'
require 'user_account_repository'
require 'pg'
require 'database_connection'
def reset_posts_table
  seed_sql = File.read('spec/seeds.sql')
  if ENV["PG_password"]
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test', password: ENV["PG_password"] })
  else
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test'})
  end
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
  # 1
  # Get all posts
  it "Get all posts" do
    repo = PostRepository.new

    posts = repo.all

    expect(posts.length).to eq  2

    expect(posts[0].id).to eq  '1'
    expect(posts[0].title).to eq 'post1'
    expect(posts[0].content).to eq  'aaa'
    expect(posts[0].view).to eq '4'
    expect(posts[0].user_account_id).to eq '1'

    expect(posts[1].id).to eq  '2'
    expect(posts[1].title).to eq  'post2'
    expect(posts[1].content).to eq  'bbb'
    expect(posts[1].view).to eq '10'
    expect(posts[1].user_account_id).to eq '2'
  end

  # 2
  # Get a single post
  it "Get a single post" do
    repo = PostRepository.new

    post = repo.find(1)

    expect(post.id).to eq '1'
    expect(post.title).to eq 'post1'
    expect(post.content).to eq 'aaa'
    expect(post.view).to eq '4'
    expect(post.user_account_id).to eq '1'

  end

    #3
    # Create a new post
  it "Create a new post" do
    repo = PostRepository.new

    post = Post.new
    post.title = "post3"
    post.content = "ccc"
    post.view = "6"
    post.user_account_id = '2'


    repo.create(post)

    posts = repo.all

    last_post = posts.last
    expect(post.title).to eq "post3"
    expect(post.content).to eq "ccc"
    expect(post.view).to eq "6"
    expect(post.user_account_id).to eq '2'
  end
    #4
    # Delete a post
  it "Delete a post" do
    repo = PostRepository.new

    repo.delete(1)

    all_posts = repo.all
    expect(all_posts.length).to eq 1
    expect(all_posts.first.id).to eq '2'
  end
    #5 
    # Update a post
  it "Update a post" do
    repo = PostRepository.new

    post = repo.find(1)

    post.title = 'post01'
    post.content = 'aaaaaa'
    post.view = '12'
    post.user_account_id = '2'

    repo.update(post)

    updated_post = repo.find(1)

    expect(updated_post.title).to eq 'post01'
    expect(updated_post.content).to eq 'aaaaaa'
    expect(updated_post.view).to eq '12'
    expect(updated_post.user_account_id).to eq'2'
  end
end