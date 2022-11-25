# posts Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `posts`*

```
# EXAMPLE

Table: posts

Columns:
id | title | content | view
```


## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (title, content, view, user_account_id) VALUES ('post1', 'aaa', '4','1');
INSERT INTO posts (title, content, view, user_account_id) VALUES ('post2', 'bbb', '10', '2');
```


Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network_test < posts.seeds.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)

class Post

  # Replace the attributes by your own columns.
  attr_accessor :id, :username, :email_add
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: posts

# Repository class
# (in lib/post_repository.rb)

class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, view, user_account_id FROM posts;

    # Returns an array of post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, view, user_account_id FROM posts WHERE id = $1;

    # Returns a single post object.
  end

  # Add more methods below for each operation you'd like to implement.

  def create(user_account)
     # INSERT INTO posts (title, content, view, user_account_id) VALUES($1, $2, $3, $4);
     #Doesn't need to return anything(only creates the record)
  end

  def update(user_account)
    #UPDATE posts SET title = $1, content = $2, view = $3 , user_account_id = $4 WHERE id = $5;
    #Doesn't need to return anything(only updates the record)
  end

  def delete(id)
    # DELETE FROM posts WHERE ID = $1;
    #Doesn't need to return anything(only deletes the record)
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all posts

repo = PostRepository.new

posts = repo.all

posts.length # =>  2

posts[0].id # =>  1
posts[0].title # =>  'post1'
posts[0].content # =>  'aaa'
posts[0].view # => '4'
posts[0].user_account_id # => '1'

posts[1].id # =>  2
posts[1].title # =>  'post2'
posts[1].content # =>  'bbb'
posts[0].view # => '10'
posts[0].user_account_id # => '2'

# 2
# Get a single post

repo = PostRepository.new

post = repo.find(1)

post.id # =>  1
post.title # =>  'post1'
post.content # =>  'aaa'
post.view # => '4'
post.user_account_id # => '1'

# Add more examples for each method

#3
# Create a new post
repo = PostRepository.new

post = Post.new
post.title = "post3"
post.content = "ccc"
post.view  = "6"
post.user_accout_id  = '2'


repo.create(post)

posts = repo.all

last_post = posts.last
post.title # => "post3"
post.content # => "ccc"
post.view # => "6"
post.user_accout_id # => '2'

#4
# Delete a post

repo = PostRepository.new

repo.delete(1)

all_posts = repo.all
all_posts.length # => 1
all_posts.first.id # => '2'

#5 
# Update a post

repo = PostRepository.new

post = repo.find(1)

post.title = 'post01'
post.content = 'aaaaaa'
post.view = '12'
post.user_account_id = '2'

repo.update(post)

updated_post = repo.find(1)

updated_post.title # => 'post01'
updated_post.content # => 'aaaaaa'
updated_post.view  # => '12'
post.user_account_id # => '2'
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/post_repository_spec.rb

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
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---
