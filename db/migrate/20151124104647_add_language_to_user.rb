class AddLanguageToUser < ActiveRecord::Migration
  def change
  	remove_column :users, :language
  end
end
