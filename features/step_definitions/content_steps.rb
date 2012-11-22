World(Default::TextContents)
When /^I create content$/ do
  # visit(new_content_path(user: my_account))
  visit("/sv/text_contents/new?location=#{my_account.location.id}")
  fill_in :data, with: new_text
  click_button 'submit'
end

Given /^I have content$/ do
  my_text_content
end

Then /^it shows up on my wall$/ do
  visit( '/sv/users/' + my_account.id.to_s)
  expect(page).to have_content(new_text)
end

When /^I update the content$/ do
  visit(edit_text_content_path('sv', my_account.contents.last))
  fill_in :text, with: new_text
  click_button 'submit'
end

Then /^the content is updated$/ do
  visit(content_path('sv', my_account.contents.last))
  expect(page).to have_content(new_text)
end

When /^I delete the content$/ do
  @deleted_content = my_text_content
  visit(content_path('sv', my_text_content))
  click_link 'delete'
end

Then /^the content is deleted$/ do
  expect(Content.all).to_not include(@deleted_content)
end

Given /^There is content$/ do
  my_text_content
end

Given /^the other user has text content$/ do
  other_text_content
end

When /^I reply to content$/ do
  visit(content_path('sv', my_text_content))
  click_link 'reply'
  fill_in :text, with: new_text_content.text
  click_button 'submit'
end

Then /^reply has parent content$/ do
  expect(my_account.contents.last.parent).to eql(my_text_content)
end

When /^I share content to a user's wall$/ do
  visit(user_path('sv',other_account))
  click_link 'add_content'
  # save_and_open_page
  fill_in :text, with: new_text_content.text
  click_button 'submit'
end

Then /^the content shows up on the user's wall$/ do
  visit(user_path('sv',other_account))
  save_and_open_page
  expect(page).to have_content(new_text_content.text)
end

When /^I publish content to target$/ do
  # Initialisation in case never used before
  other_account
  my_text_content
  # Then do the actual job
  visit(content_path('sv',my_text_content))
  click_link 'publish'
  page.select(other_account.email, :from => "contents_location")
  click_button 'submit'
end

Then /^it shows up on target wall$/ do
  visit(user_path('sv',other_account))
  expect(page).to have_content(my_text_content.description[0])
end

When /^I withdraw content from target$/ do
  visit(content_path('sv',my_text_content))
  click_link 'withdraw'
  page.select(other_account.email, :from => "contents_location")
  click_button 'submit'
end
