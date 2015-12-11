class AddColumnStatusToProject < ActiveRecord::Migration
  def change
    add_column :projects, :status, :boolean, default: true
  end
end
