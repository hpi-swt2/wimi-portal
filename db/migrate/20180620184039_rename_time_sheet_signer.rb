class RenameTimeSheetSigner < ActiveRecord::Migration
  def change
    rename_column :time_sheets, :signer, :signer_id
  end
end
