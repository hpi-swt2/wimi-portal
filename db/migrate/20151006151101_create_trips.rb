class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :title
      t.datetime :start
      t.datetime :end
      t.string :status
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
