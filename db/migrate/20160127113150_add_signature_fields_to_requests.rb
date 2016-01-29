class AddSignatureFieldsToRequests < ActiveRecord::Migration
  def change
    add_column :holidays, :user_signature, :text
    add_column :holidays, :representative_signature, :text
    add_column :trips, :user_signature, :text
    add_column :trips, :representative_signature, :text
    add_column :expenses, :user_signature, :text
    add_column :expenses, :representative_signature, :text
    add_column :time_sheets, :user_signature, :text
    add_column :time_sheets, :representative_signature, :text
  end
end
