class CreateEventAdminRightsChangeds < ActiveRecord::Migration
  def change
    create_table :event_admin_rights_changeds do |t|
      t.references :admin, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :user_is_admin

      t.timestamps null: false
    end
  end
end
