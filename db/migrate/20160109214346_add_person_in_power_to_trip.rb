class AddPersonInPowerToTrip < ActiveRecord::Migration
  def change
    change_table :trips do |t|
      t.references :person_in_power, index: true, foreign_key: true
    end
  end
end
