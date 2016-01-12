class ChangeDefaultOfHolidayStatus < ActiveRecord::Migration
  def change
  	change_column :holidays, :status, :integer, default: 'saved', null: false
  end
end
