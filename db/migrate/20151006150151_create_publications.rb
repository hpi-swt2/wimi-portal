class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :title
      t.string :venue
      t.string :type_

      t.timestamps null: false
    end
  end
end
