World(Default::Users)

Given /^I have no account$/ do
  expect(User.find_by_email(new_account.email)).to be_false
end

When /^I sign up$/ do
  visit('/users/sign_up')
  fill_in 'user_email', with: new_account.email
  fill_in 'user_password', with: new_account.password
  fill_in 'user_password_confirmation', with: new_account.password_confirmation
  click_button 'Sign up'
end

Then /^a new personal account is created$/ do
  expect(User.find_by_email(new_account.email)).to be_true
end

Given /^other user's account$/ do
  other_account
end

When /^I visit the other user's profile page$/ do
  visit(user_path('en', other_account))
end

When /^I visit the other user's wall$/ do
  visit(user_path('en', other_account))
end

Then /^I see the other user's public information$/ do
  expect(page).to have_content(other_account.email)
end

Given /^I have an account$/ do
  expect(my_account).to be_a User
end

When /^I edit my (.*)$/ do |info|
  if info == 'password'
    my_new_password = 'b4racuda'
    @old_value = User.find(my_account).encrypted_password
    visit(edit_user_registration_path(my_account))
    fill_in 'user[password]', with: my_new_password
    fill_in 'user[password_confirmation]', with: my_new_password
  end
end

When /^authenticate with my password$/ do
  fill_in 'user[current_password]', with: my_account.password
  click_button 'submit'
end

Then /^my (\w+) is updated$/ do |info|
  if info == 'password'
    expect(User.find(my_account).encrypted_password).to_not eql @old_value
  end
end


