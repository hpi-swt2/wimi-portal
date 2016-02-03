class AddSignerToTimeSheets < ActiveRecord::Migration
  def change
  	add_column :time_sheets, :signer, :integer
  end
end
