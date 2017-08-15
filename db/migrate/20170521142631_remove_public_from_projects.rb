class RemovePublicFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :public, :boolean
  end
end
