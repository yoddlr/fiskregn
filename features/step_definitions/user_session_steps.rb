Then /^I am logged in$/ do
  visit('/en')
  expect(page).to have_content('Sign out')
end

When /^I log out$/ do
  click_link('Sign out')
end

Then /^I am no longer logged in$/ do
  expect(page).to_not have_content('Sign out')
end