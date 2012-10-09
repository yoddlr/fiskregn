Given /^there is user accounts$/ do
  create :user
end

When /^I visit the global wall$/ do
  visit('/home')
end

Then /^I get a list of all users$/ do
  user_list = page.all('#users li')
  expect(user_list.length).to eql User.all.count
end