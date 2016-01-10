class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :trigger, index: true, foreign_key: true
      t.references :target, index: true, foreign_key: true
      t.references :chair, index: true, foreign_key: true
      t.integer :seclevel
      t.string :type
    end
  end
end
