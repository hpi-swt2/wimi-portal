class AddSignedToTimeSheets < ActiveRecord::Migration
  def change
  	add_column :time_sheets, :signed, :boolean, default: :false
  end
end
