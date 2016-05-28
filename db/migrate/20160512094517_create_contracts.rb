class CreateContracts < ActiveRecord::Migration
  def change
    create_table(:contracts) do |t|
      t.date :start_date
      t.date :end_date
      t.belongs_to :chair
      t.belongs_to :user, :hiwi
      t.belongs_to :user, :responsible
      t.boolean :flexible
      t.integer :hours_per_week
      t.decimal :wage_per_hour, scale: 2, precision: 5
    end
    reversible do |dir|
      dir.up do
        Contract.reset_column_information
        d_start = Date.today.beginning_of_month
        d_end = Date.today.end_of_month
        User.all.each do |u|
          if u.is_hiwi?
            chair = u.projects.first.chair
            rep = chair.representative.user
            Contract.create!(start_date: d_start, end_date: d_end, chair: chair, hiwi: u, responsible: rep, hours_per_week: 10, wage_per_hour: 10, flexible: false)
          end
        end
      end
    end
  end
end
