class RemoveAcceptedFromTimeSheets < ActiveRecord::Migration
  def change
  	remove_column :time_sheets, :accepted, :boolean
  end
end
