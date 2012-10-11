Given /^I have no account$/ do
  @user = FactoryGirl.build :user
  expect(User.find_by_email(@user.email)).to be_false
end

When /^I sign up$/ do
  visit('/users/sign_up')
  fill_in 'user_email', with: @user.email
  fill_in 'user_password', with: @user.password
  fill_in 'user_password_confirmation', with: @user.password_confirmation
  click_button 'Sign up'
end

Then /^a new personal account is created$/ do
  expect(User.find_by_email(@user.email)).to be_true
end

Given /^a user account$/ do
  @user = FactoryGirl.create :user
end

When /^I visit the users profile page$/ do
  visit(user_path('en', @user))
end

Then /^I see the users public information$/ do
  expect(page).to have_content(@user.email)
end

Given /^I have an account$/ do
  @my_account = FactoryGirl.create :user
end

When /^I edit my (.*)$/ do |info|
  if info == 'password'
    @my_new_password = 'b4racuda'
    @old_value = User.find(@my_account).encrypted_password
    visit(edit_user_registration_path(@my_account))
    fill_in 'user[password]', with: @my_new_password
    fill_in 'user[password_confirmation]', with: @my_new_password
  end
end

When /^authenticate with my password$/ do
  fill_in 'user[current_password]', with: @my_account.password
  click_button 'submit'
end

Then /^my (\w+) is updated$/ do |info|
  if info == 'password'
    expect(User.find(@my_account).encrypted_password).to_not eql @old_value
  end
end