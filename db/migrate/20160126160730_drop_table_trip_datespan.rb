class DropTableTripDatespan < ActiveRecord::Migration
  def change
  	drop_table :trip_datespans
  end
end
