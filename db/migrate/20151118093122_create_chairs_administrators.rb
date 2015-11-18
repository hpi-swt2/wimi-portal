class CreateChairsAdministrators < ActiveRecord::Migration
  def change
    create_table :chairs_administrators do |t|
      t.references :user, index: true, foreign_key: true
      t.references :chair, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
