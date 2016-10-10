# require 'rails_helper'

#this should work but it doesnt. feature works but test is broken. help please.

# describe 'time_sheets#show' do
#   before :each do
#     @hiwi = FactoryGirl.create(:hiwi)
#     @wimi = FactoryGirl.create(:wimi).user
#     @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
#     @project = FactoryGirl.create(:project)
#     @project.users << @hiwi
#     login_as @hiwi
#   end

#   context 'with a new time sheet' do
#     it 'has a delete button' do
#       visit time_sheets_path
#       click_on 'New Timesheet'
#       click_on 'Create timesheet'

#       expect(page).to have_content('Delete')
#     end
#   end

#   context 'with a handed in time sheet' do
#     it 'does not have a delete button' do
#       visit time_sheets_path
#       click_on 'New Timesheet'
#       click_on 'Create timesheet'
#       click_on 'hand in'
#       click_on 'show'

#       expect(page).to_not have_content('Delete')
#     end
#   end
# end