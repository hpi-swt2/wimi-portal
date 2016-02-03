class AddRejectionMessageToTrip < ActiveRecord::Migration
  def change
  	add_column :trips, :rejection_message, :text, default: ''
  end
end
