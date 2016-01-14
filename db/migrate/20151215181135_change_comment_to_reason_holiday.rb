class ChangeCommentToReasonHoliday < ActiveRecord::Migration
  def change
  	rename_column :holidays, :comment, :reason
  end
end
