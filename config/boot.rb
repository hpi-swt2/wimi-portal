ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'business_time'
require 'holidays'

Holidays.between(Date.today, 2.years.from_now, :de_bb, :observed).map do |holiday|
  BusinessTime::Config.holidays << holiday[:date]
  # Implement long weekends if they apply to the region, eg:
  # BusinessTime::Config.holidays << holiday[:date].next_week if !holiday[:date].weekday?
end
