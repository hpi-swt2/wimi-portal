class ChangeColumnPublicToDefaultTrue < ActiveRecord::Migration
  def change
    change_column_default :projects, :public, true
  end
end
