class AddColumnsToTimesheets < ActiveRecord::Migration
  def change
  	add_column :time_sheets, :handed_in, :boolean, default: false
  	add_column :time_sheets, :handed_in_date, :date
  	add_column :time_sheets, :accepted, :boolean, default: false
  end
end
