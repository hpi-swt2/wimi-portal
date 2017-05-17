class RemovePersonnelNumberDefault < ActiveRecord::Migration
	def self.up
		change_column_default :users, :personnel_number, nil
	end

	def self.down
		change_column_default :users, :personnel_number, 0
	end
end
