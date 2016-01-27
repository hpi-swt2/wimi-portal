class AddRejectionMessageToTimeSheets < ActiveRecord::Migration
  def change
  	add_column :time_sheets, :rejection_message, :text, default: ''
  end
end
