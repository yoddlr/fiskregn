# Grant find access
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

# Revoke find access
#
When /^I revoke find access to a user$/ do
  visit content_path('en',my_text_content)

  # Huh?! Works.. But what I get is a ul object, which I 'set' to true..
  # I don't care, the checkbox gets checked, and I don't understand how.
  # TODO: The only problem would be if the test had more than one user in the access list, as I guess they all would be revoked.
  #
  page.all('#find_access_list').each do |listitem|
    listitem.set(true)
  end

  click_button 'submit_revoke_find_access'
end

Then /^that user does not appear in the find access list$/ do
  visit content_path('en', my_text_content)
  find_access_list = page.find('#find_access_list')
  expect(find_access_list).to_not have_content(other_account.email)
end

# Grant read access
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
