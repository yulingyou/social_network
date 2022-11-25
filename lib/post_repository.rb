require_relative 'database_connection'
require_relative 'post'

class PostRepository

  def all 
    # Executes the SQL query:
    # SELECT id, title, content, view, user_account_id FROM posts;
    sql = 'SELECT id, title, content, view, user_account_id FROM posts;'
    # Returns an array of post objects.
    results_set = DatabaseConnection.exec_params(sql,[])
    posts = []
    results_set.each do |record|
      post = Post.new
      post.id = record['id']
      post.title = record['title']
      post.content = record['content']
      post.view = record['view']
      post.user_account_id = record['user_account_id']
      posts << post
    end
    return posts
  end

  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, view, user_account_id FROM posts WHERE id = $1;
    sql = 'SELECT id, title, content, view, user_account_id FROM posts WHERE id = $1;'
    result = DatabaseConnection.exec_params(sql,[id])
    # Returns a single post object.
    find_post = result[0]
    post = Post.new
    post.id = find_post['id']
    post.title = find_post['title']
    post.content = find_post['content']
    post.view = find_post['view']
    post.user_account_id = find_post['user_account_id']

    return post

  end

  # Add more methods below for each operation you'd like to implement.

  def create(post)
    # INSERT INTO posts (title, content, view, user_account_id) VALUES($1, $2, $3, $4);
    sql = 'INSERT INTO posts (title, content, view, user_account_id) VALUES($1, $2, $3, $4);'
    sql_params = [post.title, post.content, post.view, post.user_account_id]
    DatabaseConnection.exec_params(sql, sql_params)
    #Doesn't need to return anything(only creates the record)
    return nil
  end

  def update(post)
    #UPDATE posts SET title = $1, content = $2, view = $3 , user_account_id = $4 WHERE id = $5;
    sql = 'UPDATE posts SET title = $1, content = $2, view = $3, user_account_id = $4 WHERE id = $5;'
    sql_params = [post.title, post.content, post.view, post.user_account_id, post.id]
    DatabaseConnection.exec_params(sql, sql_params)
    #Doesn't need to return anything(only updates the record)
    return 
  end

  def delete(id)
    # DELETE FROM posts WHERE ID = $1;
    sql = 'DELETE FROM posts WHERE ID = $1;'
    DatabaseConnection.exec_params(sql,[id])
    #Doesn't need to return anything(only deletes the record)
    return nil
  end
end