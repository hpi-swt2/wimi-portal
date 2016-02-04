# Require the airbrake gem in your App.
# ---------------------------------------------
#
# Rails 3 - In your Gemfile
# gem 'airbreak'
#
# Rails 2 - In environment.rb
# config.gem 'airbreak'
#
# Then add the following to config/initializers/errbit.rb
# -------------------------------------------------------

Airbrake.configure do |config|
  config.api_key = ENV["ERRBIT_API_KEY"] || 'e03ec03a59077db4530328f5f20da333'
  config.host    = 'swt2-2015-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
