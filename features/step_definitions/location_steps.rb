When /^I visit the user's wall$/ do
 visit(user_path('sv', @user))
end

Then /^I see the other user's content$/ do
  expect(page).to have_content(other_text_content[0])
end

Then /^I visit my location$/ do
  visit home_path
end
