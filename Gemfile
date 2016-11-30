source 'https://rubygems.org'

ruby '2.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use Postgresql in production
gem 'pg', group: :production
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# for Windows users
gem 'nokogiri', '1.6.7.rc3', platforms: [:mswin, :mingw, :x64_mingw]
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

gem 'newrelic_rpm'
gem 'airbrake'

# add current schema to models
gem 'annotate'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Datetime validations
gem 'validates_timeliness'
# to parse date parameters from ui
gem "delocalize"
# American style month/day/year parsing for ruby 1.9
# https://github.com/jeremyevans/ruby-american_date
gem "american_date"

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Authentification
gem 'devise'
# openID Authentication
gem 'devise_openid_authenticatable'
gem 'warden'
# Use Bootstrap (app/assets/stylesheets)
gem 'therubyracer', platforms: :ruby
gem 'twitter-bootstrap-rails'
gem 'devise-bootstrap-views'
# use Bootstrap Tooltips
gem 'bootstrap-tooltip-rails'
# Use Bootstrap's popover modals instead of the browser's
# builtin confirm() API for links generated through
# Rails' "link_to" helpers with the :confirm option.
# See: https://github.com/ifad/data-confirm-modal
gem 'data-confirm-modal'

# Use Jquery as the JS lib
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Continuation of CanCan (authoriation Gem for RoR)
gem 'cancancan'

# Select2 dropdown replacement featuring autocomplete
gem 'select2-rails'

# Search Gem
gem 'searchlight'
# for nested forms
#gem 'cocoon'
gem 'business_time'
gem 'holidays'
gem 'bootstrap-datepicker-rails'
gem 'whenever'

# For generating pdfs from documents
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# Create filters easily with scopes
gem 'has_scope'

gem 'rubocop', '~> 0.29.1'

# Logging on Heroku with Rails 4
# https://devcenter.heroku.com/articles/rails4
gem 'rails_12factor', group: :production

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 3.2'
  gem 'capybara', '~> 2.5'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  
  gem 'i18n-tasks', '~> 0.9.5'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'better_errors', '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'

  # an IRB alternative and runtime developer console
  gem 'pry'
  gem 'pry-rails'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  # Coverage information
  gem 'simplecov', require: false
  # Stubbing external calls by blocking traffic with WebMock.disable_net_connect! or allow:
  #gem 'webmock'
end
