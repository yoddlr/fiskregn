Given /^there are user accounts$/ do
  create :user
end

When /^I visit the global wall$/ do
  visit('/')
end

Then /^I get a list of all locations$/ do
  location_list = page.all('#locations li')
  expect(location_list.length).to eql Location.all.count
end
