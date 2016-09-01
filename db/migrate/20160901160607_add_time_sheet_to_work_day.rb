class AddTimeSheetToWorkDay < ActiveRecord::Migration
  def change
    add_reference :work_days, :time_sheet, index: true, foreign_key: true
  end
end
