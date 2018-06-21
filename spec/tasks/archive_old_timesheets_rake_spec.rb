require 'rails_helper'

describe "rake time_sheet:archive_old", type: :task do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "archives open timesheets that are 3 months old" do
    contract = FactoryBot.create(:contract, start_date: 3.months.ago, end_date: 1.month.from_now)
    time_sheet = FactoryBot.create(:time_sheet, contract: contract, month: contract.start_date.month, year: contract.start_date.year)

    task.execute
    time_sheet.reload
    expect(time_sheet.status).to eq("closed")
  end

  it "creates and archives a timesheet if the contracts does not have one for that month" do
    contract = FactoryBot.create(:contract, start_date: 3.months.ago, end_date: 1.month.from_now)

    task.execute
    expect(TimeSheet.count).to eq(1)
    expect(TimeSheet.last.status).to eq("closed")
  end

  it "does not archive any timesheets newer than 3 months" do
    contract = FactoryBot.create(:contract, start_date: 3.months.ago, end_date: 1.month.from_now)
    time_sheet = FactoryBot.create(:time_sheet, contract: contract, month: 2.months.ago.month, year: 2.months.ago.year)

    task.execute
    time_sheet.reload
    expect(time_sheet.status).not_to eq("closed")
  end
end
