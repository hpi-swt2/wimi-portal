class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.string :destination
      t.text :reason
      t.text :annotation
      t.string :signature
      t.string :status

      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
