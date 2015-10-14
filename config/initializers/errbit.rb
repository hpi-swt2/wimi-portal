# Require the airbrake gem in your App.
# ---------------------------------------------
#
# Rails 3 - In your Gemfile
# gem 'airbrake'
#
# Rails 2 - In environment.rb
# config.gem 'airbrake'
#
# Then add the following to config/initializers/errbit.rb
# -------------------------------------------------------

Airbrake.configure do |config|
  config.api_key = 'e03ec03a59077db4530328f5f20da333'
  config.host    = 'swt2-2015-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
