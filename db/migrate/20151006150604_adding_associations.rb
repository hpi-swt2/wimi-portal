class AddingAssociations < ActiveRecord::Migration
  def change
    create_table :users_publications, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :publication, index: true
    end

    create_table :users_projects, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true
    end
  end
end
