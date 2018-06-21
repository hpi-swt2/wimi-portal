require 'rails_helper'
require 'cancan/matchers'

describe 'time sheets of a hiwi' do
	before :each do
		@hiwi = FactoryBot.create(:hiwi)
		@wimi = FactoryBot.create(:wimi).user
		@contract = FactoryBot.create(:contract, hiwi: @hiwi, responsible: @wimi)
		@time_sheet = FactoryBot.create(:time_sheet, contract: @contract)
		login_as @wimi
	end

	it "should be visible to the hiwi's assigned wimi" do
		ability = Ability.new(@wimi)
		expect(ability).to be_able_to(:show,@time_sheet)
	end
end
