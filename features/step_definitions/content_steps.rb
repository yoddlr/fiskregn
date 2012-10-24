When /^I (?:share|have) content$/ do
  # visit(new_content_path(user: @my_account))
  visit("/sv/contents/new?location=#{@my_account.location.id}")
  @text = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
  fill_in :data, with: @text
  click_button 'submit'
end

Then /^it shows up on my wall$/ do
  visit( '/sv/users/' + @my_account.id.to_s)
  expect(page).to have_content(@text)
end

When /^I update the content$/ do
  visit(edit_content_path('sv', @my_account.contents.last))
  @updated_text = 'No longer only ipsum'
  fill_in :text, with: @updated_text
  click_button 'submit'
end

Then /^the content is updated$/ do
  visit(content_path('sv', @my_account.contents.last))
  expect(page).to have_content(@updated_text)
end

When /^I delete the content$/ do
  @delete_content = @my_account.contents.last
  @deleted_text = @delete_content.text
  visit(content_path('sv', @delete_content))
  click_link 'delete'
end

Then /^the content is deleted$/ do
  expect(Content.all).to_not include(@delete_content)
end

Given /^There is content$/ do
  @parent_content = create :content, user: User.first
end

When /^I reply to content$/ do
  visit(content_path('sv', @parent_content))
  click_link 'reply'
  @child_text = 'Child data'
  fill_in :text, with: @child_text
  click_button 'submit'
end

Then /^reply has parent content$/ do
  expect(@my_account.contents.last.parent).to eql(@parent_content)
end

When /^I share content to a user's wall$/ do
  visit(user_path('sv',@user))
  click_link 'add_content'
  @wall_text = 'Shared to wall'
  fill_in :text, with: @wall_text
  click_button 'submit'
end

Then /^the content shows up on the user's wall$/ do
  visit(user_path('sv',@user))
  expect(page).to have_content(@wall_text)
end

When /^I publish content to target$/ do
  @target_user = FactoryGirl.create :user, email: 'target@user.com'
  @target_text = 'target text'
  @target_content = FactoryGirl.create :content, user: @my_account, text: @target_text
  visit(content_path('sv',@target_content))
  click_link 'publish'
  page.select(@target_user.email, :from => "contents_location")
  click_button 'submit'
end

Then /^it shows up on target wall$/ do
  # FIXME: Implement this one and "the content shows up on the user's wall" as one single parameterised step
  visit(user_path('sv',@target_user))
  expect(page).to have_content(@target_text)
end

When /^I withdraw content from target$/ do
  visit(content_path('sv',@target_content))
  click_link 'withdraw'
  page.select(@target_user.email, :from => "contents_location")
  click_button 'submit'
end

Then /^it does not show up on target wall$/ do
  visit(user_path('sv',@target_user))
  expect(page).to_not have_content(@target_text)
end