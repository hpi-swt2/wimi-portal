class CreateChairApplications < ActiveRecord::Migration
  def change
    create_table :chair_applications do |t|
      t.references :user, index: true, foreign_key: true
      t.references :chair, index: true, foreign_key: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
