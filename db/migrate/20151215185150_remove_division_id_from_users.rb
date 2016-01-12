class RemoveDivisionIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :division_id
  end
end
