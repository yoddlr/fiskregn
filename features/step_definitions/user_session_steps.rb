Given /^I sign in with my account$/ do
  visit('/en/users/sign_in')
  fill_in 'user_email', with: my_account.email
  fill_in 'user_password', with: my_account.password
  click_button 'Sign in'
end

Then /^I am signed in with my account$/ do
  visit('/en')
  expect(page).to have_content("Signed in as #{my_account.email}")
end

Given /^I have signed in with my account$/ do
  steps %{
    Given I sign in with my account
    And I am signed in with my account
  }
end

When /^I sign out$/ do
  click_link('Sign out')
end

Then /^I am not signed in$/ do
  expect(page).to_not have_content('Sign out')
end
