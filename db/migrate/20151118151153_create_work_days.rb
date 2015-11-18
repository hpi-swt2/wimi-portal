class CreateWorkDays < ActiveRecord::Migration
  def change
    create_table :work_days do |t|
      t.date :date
      t.time :start_time
      t.integer :brake
      t.time :end_time
      t.integer :duration
      t.string :attendance
      t.string :notes

      t.timestamps null: false
    end
  end
end
