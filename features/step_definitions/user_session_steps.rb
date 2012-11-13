Given /^I sign in with (.*)$/ do |account|
  account = eval(account)
  visit('/en/users/sign_in')
  fill_in 'user_email', with: account.email
  fill_in 'user_password', with: account.password
  click_button 'Sign in'
end

Then /^I am signed in with (.*)$/ do |account|
  account = eval(account)
  visit('/en')
  expect(page).to have_content("Signed in as #{account.email}")
end

Given /^I have signed in with (.*)$/ do |account|
  steps %{
    Given I sign in with #{account}
    And I am signed in with #{account}
  }
end

When /^I sign out$/ do
  click_link('Sign out')
end

Then /^I am not signed in$/ do
  expect(page).to_not have_content('Sign out')
end
