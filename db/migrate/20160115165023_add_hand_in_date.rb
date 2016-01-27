class AddHandInDate < ActiveRecord::Migration
  def change
  	add_column :time_sheets, :hand_in_date, :date
  end
end
