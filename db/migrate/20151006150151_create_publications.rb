class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :title
      t.string :venue
      t.string :type_
      t.belongs_to :project, index:true
      t.timestamps null: false
    end
  end
end
