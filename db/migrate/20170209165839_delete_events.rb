class DeleteEvents < ActiveRecord::Migration
  def change
  	drop_table :events
  end
end
