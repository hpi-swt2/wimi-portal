class AddDateToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :date_start, :date
    add_column :trips, :date_end, :date
  end
end
