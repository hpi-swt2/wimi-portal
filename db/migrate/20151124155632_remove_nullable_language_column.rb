class RemoveNullableLanguageColumn < ActiveRecord::Migration
  def self.up
  	remove_column :users, :language
  end
end
