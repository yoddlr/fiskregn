# Find access
#
When /^I grant find access to a user$/ do
  visit content_path('en',my_text_content)
  save_page
  fill_in 'grant_find_access', with: other_account.email
  click_button 'submit_grant_find_access'
end

Then /^that user appears in the find access list$/ do
  visit content_path('en', my_text_content)
  find_access_list = page.find('#find_access_list')
  expect(find_access_list).to have_content(other_account.email)
end

# Read access
#
When /^I grant read access to a user$/ do
  visit content_path('en',my_text_content)
  fill_in 'grant_read_access', with: other_account.email
  click_button 'submit_grant_read_access'
end

Then /^that user appears in the read access list$/ do
  visit content_path('en', my_text_content)
  read_access_list = page.find('#read_access_list')
  expect(read_access_list).to have_content(other_account.email)
end
