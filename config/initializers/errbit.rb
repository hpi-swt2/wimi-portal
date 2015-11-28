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

Airbreak.configure do |config|
  config.api_key = 'f52c70fc32a49a41c5e0762c267e2678'
  config.host    = 'swt2-2015-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
