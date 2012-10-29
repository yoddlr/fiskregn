When /^I tag the content$/ do
  visit(content_path('sv', @parent_content))
  @tag = 'Taggety-tag'
  fill_in :tag_list, with: @tag
  click_button 'submit'
  save_page
end

Then /^the content has the tag$/ do
  # Revisit page to do a proper read
  visit(content_path('de', @parent_content))
  expect(page).to have_content(@tag)
end