class ChangeDefaultOfHolidayStatus < ActiveRecord::Migration
  def change
  	change_column :holidays, :status, :string, default: 'edited'
  end
end
