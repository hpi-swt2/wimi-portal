require_relative '20170105094707_create_dismissed_missing_timesheets'

class DeleteDismissedMissingTimesheets < ActiveRecord::Migration
  def change
  	revert CreateDismissedMissingTimesheets
  end
end
