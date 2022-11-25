-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts RESTART IDENTITY CASCADE; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO user_accounts (username, email_add) VALUES ('David', 'david@mail.com');
INSERT INTO user_accounts (username, email_add) VALUES ('Anna', 'anna@mail.com');

INSERT INTO posts (title, content, view, user_account_id) VALUES ('post1', 'aaa', 4,'1');
INSERT INTO posts (title, content, view, user_account_id) VALUES ('post2', 'bbb', 10, '2');