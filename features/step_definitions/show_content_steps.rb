Given /^there is content$/ do
  @content = create :text_content, text: 'innehaall'
end

When /^I visit the contents page$/ do
  visit content_path('en', @content)
end

When /^I visit the page of the reply$/ do
  visit content_path('sv', @reply)
end

Then /^I see the content$/ do
  expect(page).to have_content(@content.text)
end

Given /^the content has a reply$/ do
  @reply = create :text_content, text: 'svar', parent: @content, user: User.last
end

Then /^I see a link to the parent content$/ do
  expect(page).to have_content('innehaall')
end

Then /^I also see the reply$/ do
  expect(page).to have_content(@reply.description)
end
