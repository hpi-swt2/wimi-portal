class ChangeDatetimeToDate < ActiveRecord::Migration
  def change
    remove_column :holidays, :start
    add_column :holidays, :start, :date
    remove_column :holidays, :end
    add_column :holidays, :end, :date
  end
end
