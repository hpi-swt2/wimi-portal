class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :trigger_id
      t.integer :target
      t.references :chair, index: true, foreign_key: true
      t.integer :seclevel
      t.string :type
    end
  end
end
