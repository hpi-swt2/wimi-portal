class RemoveHandedInDateFromTimeSheets < ActiveRecord::Migration
  def change
  	remove_column :time_sheets, :handed_in_date, :date
  end
end
