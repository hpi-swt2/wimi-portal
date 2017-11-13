namespace :time_sheet do
    task archive_old_time_sheets: :environment do
        date = Date.new(Date.today.year, Date.today.month - 3)
        Contract.month(date.month,date.year).each do |c|
            # sideeffect of time_sheet: creates a new one if it doesnt exist for this month
            ts = c.time_sheet(date.month, date.year)
            unless ts.status == "accepted"
                ts.update(status: 'closed', handed_in: false)
            end
        end
    end
end