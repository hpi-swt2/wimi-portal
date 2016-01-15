class AddCommentToHoliday < ActiveRecord::Migration
  def change
  	add_column :holidays, :comment, :string
  	add_column :holidays, :annotation, :string
  end
end
