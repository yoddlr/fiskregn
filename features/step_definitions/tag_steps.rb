When /^I tag (.*)$/ do |the_content|
  the_content = eval(the_content)
  visit(content_path('sv', the_content))
  @tag = 'Taggety-tag'  
  fill_in "text_content[tag_strings]", with: @tag
  save_page
  click_button 'submit'
end

Then /^(.*) has the tag$/ do |the_content|
  the_content = eval(the_content)
  # Revisit page to do a proper read
  visit(content_path('de', the_content))
  expect(page).to have_content(@tag)
end
