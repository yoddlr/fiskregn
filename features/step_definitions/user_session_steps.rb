Then /^I am signed in$/ do
  visit('/en')
  expect(page).to have_content('Sign out')
end


Given /^I (?:sign|have signed) in$/ do
  visit('/en/users/sign_in')
  fill_in 'user_email', with: @my_account.email
  fill_in 'user_password', with: @my_account.password
  click_button 'Sign in'
end

When /^I sign out$/ do
  click_link('Sign out')
end

Then /^I am not signed in$/ do
  expect(page).to_not have_content('Sign out')
end