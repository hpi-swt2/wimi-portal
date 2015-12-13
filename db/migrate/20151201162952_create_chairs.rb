class CreateChairs < ActiveRecord::Migration
  def change
    create_table :chairs do |t|
      t.string :name
      t.string :abbreviation
      t.string :description

      t.timestamps null: false
    end
  end
end
