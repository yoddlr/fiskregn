When /^I share content$/ do
  visit(new_content_path(user: @my_account))
  @data = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
  fill_in :data, with: @data
  click_button 'submit'
end

Then /^it shows up on my wall$/ do
  visit( '/sv/users/' + @my_account.id.to_s)
  expect(page).to have_content(@data)
end