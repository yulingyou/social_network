require_relative 'database_connection'
require_relative 'user_account'

class UserAccountRepository

  def all
    # Executes the SQL query:
    # SELECT id, username, email_add FROM user_accounts;
    sql = 'SELECT id, username, email_add FROM user_accounts;'
    result_set = DatabaseConnection.exec_params(sql, [])

    user_accounts = []

    result_set.each do |record|
      user_account = UserAccount.new
      user_account.id = record['id']
      user_account.username = record['username']
      user_account.email_add = record['email_add']
      user_accounts << user_account
    end

    return user_accounts


    # Returns an array of user_account objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, username, email_add FROM user_accounts WHERE id = $1;

    sql = 'SELECT id, username, email_add FROM user_accounts WHERE id = $1;'
    params = [id]
    result = DatabaseConnection.exec_params(sql, params)
    # Returns a single user_account object.
    user_result = result[0]
    user = UserAccount.new
    user.id = user_result['id']
    user.username = user_result['username']
    user.email_add = user_result['email_add']

    return user

  end

  # Add more methods below for each operation you'd like to implement.

  def create(user_account)
     # INSERT INTO user_accounts (username, email_add) VALUES($1, $2);
     #Doesn't need to return anything(only creates the record)
     sql = 'INSERT INTO user_accounts (username, email_add) VALUES($1, $2);'
     sql_params = [user_account.username, user_account.email_add]
     return nil
  end

  def update(user_account)
    #UPDATE user_accounts SET username = $1, email_add = $2, WHERE id = $3;
    #Doesn't need to return anything(only updates the record)
    sql = 'UPDATE user_accounts SET username = $1, email_add = $2 WHERE id = $3;'
    sql_params = [user_account.username, user_account.email_add, user_account.id]

    DatabaseConnection.exec_params(sql, sql_params)
    return nil
  end

  def delete(id)
    # DELETE FROM user_accounts WHERE ID = $1;
    sql = 'DELETE FROM user_accounts WHERE ID = $1;'
    #Doesn't need to return anything(only deletes the record)
    DatabaseConnection.exec_params(sql, [id])
    return nil
  end

end