class AddDaysAbroadToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :days_abroad, :integer
  end
end
