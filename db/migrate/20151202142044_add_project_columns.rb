class AddProjectColumns < ActiveRecord::Migration
  def change
    add_column :projects, :description, :string, default: ''
    add_column :projects, :public, :boolean, default: false
    add_column :projects, :active, :boolean, default: true
    add_column :projects, :chair, :integer, references: :chairs, default: nil
  end
end
