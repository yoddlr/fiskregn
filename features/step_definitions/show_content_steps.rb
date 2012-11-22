World(Default::TextContents)
World(Default::Users)
Given /^there is content$/ do
  # Note: We define/create the World's Default::TextContents variable @text_content here:
  # Note: Must tag my_account so it have find and read access to the text_content.

  # By some fantastic ruby logic, eval() will convert the 'my_account' string into the object my_account
  steps %{
    Given I sign in with my_account
    And I am signed in with my_account
  }

  text_content
  my_account.tag(text_content, :with => ['find','read'], :on => 'access')
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
  visit(user_path('sv',other_account))
  expect(page).to_not have_content(my_text_content.description[0])
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
