require 'rails_helper'

RSpec.describe 'dashboard/index.html.erb', type: :view do
  before :each do
    @hiwi = FactoryGirl.create(:user)
    @hiwi2 = FactoryGirl.create(:user)
    @wimi = FactoryGirl.create(:user)
    @representative = FactoryGirl.create(:user)
    @chair = FactoryGirl.create(:chair)
    FactoryGirl.create(:wimi, user: @wimi, chair: @chair)
    FactoryGirl.create(:representative, user: @representative, chair: @chair)
    @project = FactoryGirl.create(:project, chair: @chair)
    @project.users << @hiwi
    @project.users << @wimi
    @contract = FactoryGirl.create(:contract, chair: @chair, responsible: @wimi, hiwi: @hiwi)
    @contract2 = FactoryGirl.create(:contract, chair: @chair, responsible: @representative, hiwi: @hiwi2)

    @project2 = FactoryGirl.create(:project, chair: @chair)
    @project2.users << @hiwi2
    @project2.users << @representative

    @chair_other = FactoryGirl.create(:chair)
    @representative_other = @chair_other.representative.user
    @wimi_other = FactoryGirl.create(:wimi, chair: @chair_other).user
    
  end

  context 'roles see only their respective events:' do
    before :each do
      Event.add('default', @wimi, nil , @hiwi) # all should see this
      Event.add('default', @representative, nil, @wimi) # hiwi cant see this
      Event.add('default', @representative, nil, @hiwi2) # hiwi and wimi cant see this
      Event.add('default', @representative_other, nil, @wimi_other) # none can see this

      expect(Event.all.count).to eq(4)
    end


  	it 'hiwis where they are user or target_user' do
  		ability = Ability.new(@hiwi)

  		expect(ability.can?(:show, Event.first)).to be true
      expect(ability.can?(:show, Event.second)).to be false
      expect(ability.can?(:show, Event.third)).to be false
      expect(ability.can?(:show, Event.fourth)).to be false
  	end

    it 'wimis where user/target_user is in the same project' do
      ability = Ability.new(@wimi)

      expect(ability.can?(:show, Event.first)).to be true
      expect(ability.can?(:show, Event.second)).to be true
      expect(ability.can?(:show, Event.third)).to be false
      expect(ability.can?(:show, Event.fourth)).to be false
    end

    it 'admin/representative where user/target_user is in the same chair' do
      ability = Ability.new(@representative)

      expect(ability.can?(:show, Event.first)).to be true
      expect(ability.can?(:show, Event.second)).to be true
      expect(ability.can?(:show, Event.third)).to be true
      expect(ability.can?(:show, Event.fourth)).to be false
    end
  end
end