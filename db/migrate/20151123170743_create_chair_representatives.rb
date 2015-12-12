class CreateChairRepresentatives < ActiveRecord::Migration
  def change
    create_table :chair_representatives do |t|
      t.references :user, index: true, foreign_key: true
      t.references :chair, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
