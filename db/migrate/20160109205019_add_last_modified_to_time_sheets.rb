class AddLastModifiedToTimeSheets < ActiveRecord::Migration
  def change
  	add_column :time_sheets, :last_modified, :date
  end
end
