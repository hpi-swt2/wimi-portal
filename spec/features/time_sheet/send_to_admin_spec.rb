require 'rails_helper'
require 'cancan/matchers'

describe 'timesheet#show' do 
  
	context 'with an accepted time sheet' do 
		before :each do
			@contract = FactoryGirl.create(:contract)
			@time_sheet = FactoryGirl.create(:time_sheet_accepted, contract: @contract)
			@user = @time_sheet.user
			@wimi = @time_sheet.contract.responsible
		end
    
		it 'should allow the responsible wimi to send the pdf to the admin' do
			ability = Ability.new(@wimi)
			expect(ability).to be_able_to(:send_to_admin, @time_sheet)
		end
    
		it 'should have a button for sending the pdf to the admin' do
			login_as @wimi
			visit time_sheet_path(@time_sheet)
      
			expect(page).to have_selector(:linkhref, send_to_admin_time_sheet_path(@time_sheet))
		end
	end	
end

RSpec.describe TimeSheetsController, type: :controller do
	before :each do
    @chair = FactoryGirl.create(:chair)
    @admin = FactoryGirl.create(:user)
	@contract = FactoryGirl.create(:contract,chair: @chair)
	@wimi = @contract.responsible
	@timesheet = FactoryGirl.create(:time_sheet_accepted, contract: @contract)
	FactoryGirl.create(:admin, chair: @chair, user: @admin)
	@admin.update(event_settings: [Event.types[:time_sheet_admin_mail]])
	@admin.reload
    login_with @wimi
	end
  
	context 'timesheet#send_to_admin' do
		context 'with an accepted timesheet' do
			it 'should send a mail to the admin' do
        		expect(Ability.new @wimi).to be_able_to(:send_to_admin, @timesheet)
				expect{ get :send_to_admin, {id: @timesheet.id} }.to change(ActionMailer::Base.deliveries, :count).by(1)
        		expect(response).to redirect_to(time_sheet_path(@timesheet))
			end
		end
	end
end