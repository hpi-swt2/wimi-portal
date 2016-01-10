require 'rails_helper'	

RSpec.describe "work_days/index.html.erb", type: :view do
	before :each do
		@superadmin = FactoryGirl.create(:user)
	    @superadmin.superadmin = true
	    @chair = FactoryGirl.create(:chair)
    	ChairWimi.create(user: @superadmin, chair: @chair, representative: true)
    	login_as(@superadmin, scope: :user)
    	@project = FactoryGirl.create(:project)
    end

	it 'expects sign-button for not handed in timesheets' do
		TimeSheet.create(month: Date.today.month, year: Date.today.year, salary: 100, 
		salary_is_per_month: true, workload: 100, workload_is_per_month: true,
		user_id: @superadmin.id, project_id: @project.id, handed_in: false)
	    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @superadmin.id)
	    page.should have_selector("input[type=submit][value='sign']")
	    #page.find('.sign', visible: false)
    	#expect(page).to have_content('sign')
	end

	it 'expects sign-button for handed in timesheets' do
		TimeSheet.create(month: Date.today.month, year: Date.today.year, salary: 100, 
		salary_is_per_month: true, workload: 100, workload_is_per_month: true,
		user_id: @superadmin.id, project_id: @project.id, handed_in: true, last_modified: Date.today)
		visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @superadmin.id)
		page.should have_selector("input[type=submit][value='sign']")
		#page.find('.sign', visible: false)
		#expect(page).to have_content('sign')
	end

	it 'expects reject-button for handed in timesheets' do
		TimeSheet.create(month: Date.today.month, year: Date.today.year, salary: 100, 
		salary_is_per_month: true, workload: 100, workload_is_per_month: true,
		user_id: @superadmin.id, project_id: @project.id, handed_in: true, last_modified: Date.today)
		visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @superadmin.id)
		page.should have_selector("input[type=submit][value='reject']")
		#page.find('.reject', visible: false)
		#expect(page).to have_content('reject')	
	end

end



