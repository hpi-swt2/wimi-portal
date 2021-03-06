class AddContractRefToTimeSheets < ActiveRecord::Migration
  def up
    add_reference :time_sheets, :contract, index: true, foreign_key: true
    execute "UPDATE time_sheets SET contract_id = (SELECT MIN(c.id) FROM contracts c WHERE c.hiwi_id = user_id)"
    execute "DELETE FROM time_sheets WHERE contract_id IS NULL"
    change_column_null :time_sheets, :contract_id, false
    remove_reference :time_sheets, :project
    remove_reference :time_sheets, :user
    remove_column :time_sheets, :salary
    remove_column :time_sheets, :salary_is_per_month
    remove_column :time_sheets, :workload
    remove_column :time_sheets, :workload_is_per_month
  end
end
