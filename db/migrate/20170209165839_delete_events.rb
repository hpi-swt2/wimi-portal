class DeleteEvents < ActiveRecord::Migration
  def change
  	drop_table :user_events
  	drop_table :events
  end
end
