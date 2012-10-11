When /^I (?:share|have) content$/ do
  visit(new_content_path(user: @my_account))
  @data = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
  fill_in :data, with: @data
  click_button 'submit'
end

Then /^it shows up on my wall$/ do
  visit( '/sv/users/' + @my_account.id.to_s)
  expect(page).to have_content(@data)
end

When /^I update the content$/ do
  visit(edit_content_path('sv', @my_account.contents.last))
  @updated_data = 'No longer only ipsum'
  fill_in :data, with: @updated_data
  click_button 'submit'
end

Then /^the content is updated$/ do
  visit(content_path('sv', @my_account.contents.last))
  expect(page).to have_content(@updated_data)
end

When /^I delete the content$/ do
  @delete_content = @my_account.contents.last
  @deleted_data = @delete_content.data
  visit(content_path('sv', @delete_content))
  click_link 'Delete'
end

Then /^the content is deleted$/ do
  visit(content_path('sv', @delete_content))
  expect(page).to_not have_content @deleted_data
end