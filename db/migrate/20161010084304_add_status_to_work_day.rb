class AddStatusToWorkDay < ActiveRecord::Migration
  def change
    add_column :work_days, :status, :string
  end
end
