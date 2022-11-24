# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `user_accounts`*

```
# EXAMPLE

Table: user_accounts

Columns:
id | username | email_add
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

TRUNCATE TABLE user_accounts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO user_accounts (username, email_add) VALUES ('David', 'david@mail.com');
INSERT INTO user_accounts (username, email_add) VALUES ('Anna', 'anna@mail.com');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network_test < seeds.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: user_accounts

# Model class
# (in lib/user_account.rb)
class UserAccount
end

# Repository class
# (in lib/user_account_repository.rb)
class UserAccountRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: user_accounts

# Model class
# (in lib/user_account.rb)

class UserAccount

  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :cohort_name
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
# Table name: user_accounts

# Repository class
# (in lib/user_account_repository.rb)

class UserAccountRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, username, email_add FROM user_accounts;

    # Returns an array of user_account objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, username, email_add FROM user_accounts WHERE id = $1;

    # Returns a single user_account object.
  end

  # Add more methods below for each operation you'd like to implement.

  def create(user_account)
     # INSERT INTO user_accounts (username, email_add) VALUES($1, $2);
     #Doesn't need to return anything(only creates the record)
  end

  def update(user_account)
    #UPDATE user_accounts SET username = $1, email_add = $2, WHERE id = $3;
    #Doesn't need to return anything(only updates the record)
  end

  def delete(user_account)
    # DELETE FROM user_accounts WHERE ID = $1;
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
# Get all user_accounts

repo = User_AccountRepository.new

user_accounts = repo.all

user_accounts.length # =>  2

user_accounts[0].id # =>  1
user_accounts[0].username # =>  'David'
user_accounts[0].email_add # =>  'david@mail.com'

user_accounts[1].id # =>  2
user_accounts[1].username # =>  'Anna'
user_accounts[1].email_add # =>  'anna@mail.com'

# 2
# Get a single user_account

repo = UserAccountRepository.new

user_account = repo.find(1)

user_account.id # =>  1
user_account.username # =>  'David'
user_account.email_add # =>  'david@mail.com'

# Add more examples for each method

#3
# Create a new user_account
repo = UserAccountRepository.new

user_account = UserAccount.new
user_account.username = "Max"
user_account.email_add = "max@mail.com"


repo.create(user_account)

user_accounts = repo.all

last_user_account = user_accounts.last
user_account.username # => "Max"
user_account.email_add # => "max@mail.com"

#4
# Delete a user_account

repo = UserAccountRepository.new

repo.delete(1)

all_user_accounts = repo.all
all_user_accounts.length # => 1
all_user_accounts.first.id # => '2'

#5 
# Update a user_account

repo = UserAccountRepository.new

user_accounts = repo.find(1)

user_accounts.username = 'David2'
user_accounts.email_add = 'david2@mail.com'

repo.update(user_accounts)

updated_user_accounts = repo.find(1)

updated_user_accounts.username # => 'David2'
updated_user_accounts.email_add # => 'david2@mail.com'
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/user_account_repository_spec.rb

def reset_user_accounts_table
  seed_sql = File.read('spec/seeds.sql')
  if ENV[PG_password]
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test', password: ENV[PG_password] })
  else
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test'})
  end
  connection.exec(seed_sql)
end

describe UserAccountRepository do
  before(:each) do 
    reset_user_accounts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---
