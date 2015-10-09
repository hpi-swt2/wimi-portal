class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :title
      t.datetime :start
      t.datetime :end
      t.string :status
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
