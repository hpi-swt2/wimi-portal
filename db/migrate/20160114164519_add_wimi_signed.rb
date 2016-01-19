class AddWimiSigned < ActiveRecord::Migration
  def change
  	add_column :time_sheets, :wimi_signed, :boolean, default: :false
  end
end
