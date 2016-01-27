class AddStatusToTimeSheets < ActiveRecord::Migration
  def change
  	add_column :time_sheets, :status, :integer, default: 0
  end
end
