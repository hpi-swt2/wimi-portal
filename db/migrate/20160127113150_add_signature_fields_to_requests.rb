class AddSignatureFieldsToRequests < ActiveRecord::Migration
  def change
    add_column :holidays, :user_signature, :text
    add_column :holidays, :representative_signature, :text
    add_column :trips, :user_signature, :text
    add_column :trips, :representative_signature, :text
    add_column :travel_expense_reports, :user_signature, :text
    add_column :travel_expense_reports, :representative_signature, :text
  end
end
