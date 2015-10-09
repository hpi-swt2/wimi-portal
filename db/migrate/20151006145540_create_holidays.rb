class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string :status
      t.datetime :start
      t.datetime :end
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
