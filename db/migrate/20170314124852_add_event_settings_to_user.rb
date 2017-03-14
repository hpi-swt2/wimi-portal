class AddEventSettingsToUser < ActiveRecord::Migration
  def change
    add_column :users, :event_settings, :string
  end
end
