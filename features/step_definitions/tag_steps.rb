When /^I tag the content$/ do
  visit(content_path('sv', @parent_content))
  @tag = 'Taggety-tag'  
  fill_in "text_content[tag_strings]", with: @tag
  save_page
  click_button 'submit'
end

Then /^the content has the tag$/ do
  # Revisit page to do a proper read
  visit(content_path('de', @parent_content))
  expect(page).to have_content(@tag)
end
