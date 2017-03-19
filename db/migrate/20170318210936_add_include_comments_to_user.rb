class AddIncludeCommentsToUser < ActiveRecord::Migration
  def change
    add_column :users, :include_comments, :integer
  end
end
