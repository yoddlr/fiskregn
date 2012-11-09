When /^I visit the user's wall$/ do
 visit(user_path('sv', @user))
end

Then /^I see the user's content$/ do
  # header = page.find('h1')
  expect(page).to have_content(@user.email)
end

Then /^I visit my location$/ do
  visit home_path
end