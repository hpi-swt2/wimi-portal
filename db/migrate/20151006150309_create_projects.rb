class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.boolean :status, default: true
      t.boolean :public, default: true

      t.timestamps null: false
    end
  end
end
