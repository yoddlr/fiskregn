World(Default::TextContents)
Given /^there is content$/ do
  # Note: We define/create the World's Default::TextContents variable @text_content here:
  text_content
end

When /^I visit the contents page$/ do
  visit content_path('en', text_content)
end

When /^I visit the page of the reply$/ do
  visit content_path('sv', reply)
end

Then /^I see the content$/ do
  # Note: We use the World's Default::TextContents::text_content function here:

  # NOTE: As have_content fails to compare the text array with the content on the page, let's fetch the first text part.
  expect(page).to have_content(text_content.text[0])
end

Then /^I see my new content$/ do
  visit unpublished_content_path
  expect(page).to have_content(@text)
end

Given /^the content has a reply$/ do
  reply = create :text_content, text: 'svar', parent: text_content, user: User.last
end

Then /^I see a link to the parent content$/ do
  expect(page).to have_content('innehaall')
end

Then /^I also see the reply$/ do
  expect(page).to have_content(reply.description)
end

When /^I visit my unpublished content$/ do
  visit unpublished_content_path
end

Then /^it does not show up on target wall$/ do
  visit(user_path('sv',@target_user))
  expect(page).to_not have_content(@target_text)
end

When /^I visit the content page$/ do
  @new_content = my_account.contents.last
  visit content_url(locale: 'en', id: @new_content.id)
end

Then /^the content has no tags$/ do
  tag_list = page.find('#tag_list')
  expect(tag_list).to_not have_content('li')
end

Then /^the content has no read accessors$/ do
  read_access_list = page.find('#read_access_list')
  expect(read_access_list).to_not have_content('li')
end

Then /^the content has no find accessors$/ do
  find_access_list = page.find('#find_access_list')
  expect(find_access_list).to_not have_content('li')
end

Then /^I don't see my new content$/ do
  visit unpublished_content_path
  expect(page).to have_content(@text)
end
