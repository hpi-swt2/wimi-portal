class AddFieldsToHoliday < ActiveRecord::Migration
  def change
    add_column :holidays, :replacement_user_id, :integer
    add_column :holidays, :length, :integer
    add_column :holidays, :signature, :boolean
    add_column :holidays, :last_modified, :date
    add_column :holidays, :reason, :string
    add_column :holidays, :annotation, :string
    change_column :holidays, :status, :integer, default: 'saved', null: false
  end
end
