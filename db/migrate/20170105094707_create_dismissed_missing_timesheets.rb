class CreateDismissedMissingTimesheets < ActiveRecord::Migration
  def change
    create_table :dismissed_missing_timesheets do |t|
      t.references :user, index: true, foreign_key: true
      t.references :contract, index: true, foreign_key: true
      t.date :month

      t.timestamps null: false
    end
  end
end
