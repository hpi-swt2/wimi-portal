namespace :db do
  task add_demo_data: :environment do

    puts 'creating admin, representative and wimi'
    # define users
    epic_admin = FactoryGirl.create(:user, first_name: 'Admin', last_name: 'Epic')
    epic_representative = FactoryGirl.create(:user,first_name: 'Representative', last_name: 'Epic')
    epic_wimi = FactoryGirl.create(:user,first_name: 'Wimi', last_name: 'Epic')
    
    puts 'creating hiwis'
    epic_hiwis = []
    5.times{
        user = FactoryGirl.create(:user)
        epic_hiwis << user
    }

    puts 'creating chairs'
    # create! chairs
    2.times{FactoryGirl.create(:chair, representative: false)}
    chair_epic = Chair.first
    chair_www = Chair.second

    puts 'setting user roles'
    # set user roles
    FactoryGirl.create(:admin, user: epic_admin, chair: chair_epic)
    FactoryGirl.create(:representative, user: epic_representative, chair: chair_epic)
    FactoryGirl.create(:wimi, user: epic_wimi, chair: chair_epic)

    puts 'setting up projects'
    # projects
    projects = []
    4.times {
        projects << FactoryGirl.create(:project, chair: chair_epic)
    }
    4.times { |i|
        projects[i].users << epic_wimi
    }
    project_assignments = [[0,1],[1,2,3],[1,3],[0,2],[3]]
    5.times do |i|
        project_assignments[i].each {|p| projects[p].users << epic_hiwis[i]}
    end

    puts 'creating contracts'
    #contracts
    start_dates = [5.months.ago, 7.months.ago, 10.months.ago, 3.months.ago, 6.months.ago]
    end_dates = [3.months.since, 3.months.since, 5.months.since, 8.months.since, 4.months.since]
    flexible = [false,false,true,true,true]

    contracts = []
    flexible_contracts = []
    5.times do |i|
        c = FactoryGirl.create(:contract, chair: chair_epic, hiwi: epic_hiwis[i], responsible: epic_wimi, start_date: start_dates[i], end_date: end_dates[i], flexible: flexible[i])
        contracts << c
        if flexible[i]
            flexible_contracts << c
        end
    end

    puts 'building timesheets and workdays'
    # timesheets

    contracts.each do |contract|
        date = contract.start_date
        while date <= 1.month.ago.to_date
            ts = FactoryGirl.create(:time_sheet_accepted, year: date.year, month: date.month, contract: contract, create_workdays: true)
            if contract.hiwi.projects.count > 1
                contract.hiwi.projects.each do |project|
                    FactoryGirl.create(:work_day, time_sheet: ts, project: project)
                end
            end
            date = date >> 1
        end
    end
  end
end