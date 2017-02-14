require 'rails_helper'

RSpec.describe 'dashboard/index.html.erb', type: :view do
  before :each do
    @hiwi = FactoryGirl.create(:user)
    @wimi = FactoryGirl.create(:user)
    @representative = FactoryGirl.create(:user)
    @chair = FactoryGirl.create(:chair)
    FactoryGirl.create(:wimi, user: @wimi, chair: @chair)
    FactoryGirl.create(:representative, user: @representative, chair: @chair)
    @project = FactoryGirl.create(:project, chair: @chair)
    @project.users << @hiwi
    @project.users << @wimi
    @contract = FactoryGirl.create(:contract, chair: @chair, responsible: @wimi, hiwi: @hiwi)
  end

  context 'roles see only their respective events:' do
  	it 'hiwis' do
  		time_sheet = FactoryGirl.create(:time_sheet, contract: @contract)
  		time_sheet.hand_in(@hiwi)
  		ability = Ability.new(@hiwi)

  		expect(Event.all.count).to eq(1)
  		expect(ability.can?(:show, Event.first)).to be true

  		login_as @hiwi
  		visit dashboard_path
  		expect(page).to have_content(I18n.t('dashboard.index.notifications'))
  	end
  end

  #TODO: do other roles
  # also test all other events

end