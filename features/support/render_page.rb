After do |scenario|
  if(scenario.failed?)
    # Save html output from capybara to tmp/capybara
    save_page
    # use save_and_open_page and gem launchy to automatically open page in default browser
  end
end