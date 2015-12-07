class AddNotNullableLanguageColumnWithDefaultValue < ActiveRecord::Migration
  def change
  	add_column :users, :language, :string, :default => "en", :null => false
  end
end
