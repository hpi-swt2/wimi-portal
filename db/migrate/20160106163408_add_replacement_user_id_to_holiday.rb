class AddReplacementUserIdToHoliday < ActiveRecord::Migration
  def change
  	add_column :holidays, :replacement_user_id, :integer
  	add_column :holidays, :length, :integer
  end
end
