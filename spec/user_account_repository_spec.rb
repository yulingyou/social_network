require 'user_account_repository'

def reset_user_accounts_table
  seed_sql = File.read('spec/seeds.sql')
  if ENV["PG_password"]
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test', password: ENV["PG_password"] })
  else
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test'})
  end
  connection.exec(seed_sql)
end

describe UserAccountRepository do
  before(:each) do 
    reset_user_accounts_table
  end

  it "returns all user account" do
    repo = UserAccountRepository.new

    user_accounts = repo.all

    expect(user_accounts.length).to eq 2

    expect(user_accounts[0].id).to eq '1'
    expect(user_accounts[0].username).to eq 'David'
    expect(user_accounts[0].email_add).to eq 'david@mail.com'

    expect(user_accounts[1].id).to eq '2'
    expect(user_accounts[1].username).to eq 'Anna'
    expect(user_accounts[1].email_add).to eq 'anna@mail.com'

  end

    # 2
    # Get a single user_account
  it "Get a single user_account" do
    repo = UserAccountRepository.new

    user_account = repo.find(1)

    expect(user_account.id).to eq '1'
    expect(user_account.username).to eq 'David'
    expect(user_account.email_add).to eq 'david@mail.com'

  end
    #3
    # Create a new user_account
  it "Create a new user_account" do
    repo = UserAccountRepository.new

    user_account = UserAccount.new
    user_account.username = "Max"
    user_account.email_add = "max@mail.com"


    repo.create(user_account)

    user_accounts = repo.all

    last_user_account = user_accounts.last
    expect(user_account.username).to eq "Max"
    expect(user_account.email_add).to eq "max@mail.com"
  end
    #4
    # Delete a user_account
  it "Delete a user_account" do 

    repo = UserAccountRepository.new

    repo.delete(1)

    all_user_accounts = repo.all
    expect(all_user_accounts.length).to eq 1
    expect(all_user_accounts.first.id).to eq '2'
  end
    #5 
    # Update a user_account
  it "Update a user_account" do 
    repo = UserAccountRepository.new

    user_accounts = repo.find(1)

    user_accounts.username = 'David2'
    user_accounts.email_add = 'david2@mail.com'

    repo.update(user_accounts)

    updated_user_accounts = repo.find(1)

    expect(updated_user_accounts.username).to eq 'David2'
    expect(updated_user_accounts.email_add).to eq 'david2@mail.com'
  end

end