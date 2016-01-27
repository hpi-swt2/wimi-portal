class AddLastModifiedToTrip < ActiveRecord::Migration
  def change
  	add_column :trips, :last_modified, :date
  end
end
