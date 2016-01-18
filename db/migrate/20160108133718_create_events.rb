class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :trigger, index: true
      t.references :target, index: true
      t.references :chair, index: true, foreign_key: true
      t.integer :seclevel
      t.string :type

      t.timestamps null: false
    end
  end
end
