class AddLengthLastYear < ActiveRecord::Migration
  def change
  	add_column :holidays, :length_last_year, :integer, default: 0
  end
end
