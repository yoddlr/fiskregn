source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'devise'
gem 'rails-i18n'

gem 'acts-as-taggable-on'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


# gem 'bcrypt-ruby'

# provides validation messages to generated forms
gem 'dynamic_form'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test, :development do
  gem 'sqlite3'
  gem 'faker'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard-rspec' # automatically run tests based on filechange
  gem 'guard-spork' # speed up testing by providing a test envirionment
  # Notifications for guard
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl' if RUBY_PLATFORM =~ /darwin/i # notification framework for osx
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'capybara-webkit'
  gem 'database_cleaner'
end

group :production do
  gem 'pg' # gem for postgresql
end
