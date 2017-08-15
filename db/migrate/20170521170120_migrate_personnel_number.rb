class MigratePersonnelNumber < ActiveRecord::Migration
  def up
  	User.where(personnel_number:0).each do |user|
  		user.update(personnel_number: nil)
  	end
  end

  def down
  	User.where(personnel_number:nil).each do |user|
  		user.update(personnel_number: 0)
  	end
  end
end
