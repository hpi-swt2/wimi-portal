require 'rails_helper'

RSpec.describe 'dashboard/index.html.erb' do
  context 'roles see only their respective events:' do
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

  context 'Events are created on' do
    context 'time_sheet' do
      before :each do
        @sheet = FactoryGirl.create(:time_sheet)
        @user = @sheet.contract.hiwi
      end

      it 'hand in' do
        @sheet.hand_in(@user)

        expect(Event.all.count).to eq(1)
        expect(Event.first.type).to eq('time_sheet_hand_in')
      end

      it 'accept' do
        @sheet.accept_as(@sheet.contract.responsible)

        expect(Event.all.count).to eq(1)
        expect(Event.first.type).to eq('time_sheet_accept')
      end

      it 'decline' do
        @sheet.reject_as(@sheet.contract.responsible)

        expect(Event.all.count).to eq(1)
        expect(Event.first.type).to eq('time_sheet_decline')
      end
    end

    context 'project' do
      before :each do
        @chair = FactoryGirl.create(:chair)
        @representative = @chair.representative.user
        @user = FactoryGirl.create(:user)
        @contract = FactoryGirl.create(:contract, hiwi: @user, chair: @chair)
        login_as @representative
      end

      it 'creation' do
        visit new_project_path
        fill_in('Title', with: "Example Project")
        click_on('Create project')

        expect(Event.all.count).to eq(1)
      end
    end
  end
end

RSpec.describe ChairsController, type: :controller do
  before :each do
    @chair = FactoryGirl.create(:chair)
    @representative = @chair.representative.user
    @user = FactoryGirl.create(:user)
    login_with @representative
  end


  context 'Events are created on' do
    it 'adding a user' do
      post :add_user, id: @chair.id, add_user_to_chair: { id: @user.id }

      expect(flash[:success]).to eq(I18n.t('chair.user.successfully_added', name: @user.name))
      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('chair_join')
    end

    it 'removing a user' do
      FactoryGirl.create(:wimi, user: @user, chair: @chair)
      delete :remove_user, id: @chair.id, request: @user.chair_wimi.id

      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('chair_leave')
    end

    it 'granting admin rights to a user' do
      FactoryGirl.create(:wimi, user: @user, chair: @chair)
      post :set_admin, id: @chair.id, request: @user.chair_wimi.id

      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('chair_add_admin')
    end
  end
end

RSpec.describe ProjectsController, type: :controller do
  before :each do
    @chair = FactoryGirl.create(:chair)
    @representative = @chair.representative.user
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, chair: @chair)
    @project.users << @representative
    login_with @representative
  end


  context 'Events are created on' do
    it 'adding a user' do
      post :add_user, id: @project.id, add_user_to_project: { id: @user.id }

      expect(flash[:success]).to eq(I18n.t('project.user.successfully_added', name: @user.name))
      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('project_join')
    end

    it 'removing a user' do
      @project.users << @user
      delete :remove_user, id: @project.id, user: @user.id

      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('project_leave')
    end
  end
end

RSpec.describe ContractsController, type: :controller do
  before :each do
    @chair = FactoryGirl.create(:chair)
    @representative = @chair.representative.user
    @user = FactoryGirl.create(:user)

    login_with @representative
  end

  context 'Events are created on' do
    it 'creating a contract' do
      @contract = FactoryGirl.build(:contract, chair: @chair, hiwi: @user)
      post :create, contract: @contract.attributes

      expect(flash[:success]).to eq(I18n.t('helpers.flash.created', model: @contract.model_name.human.titleize))
      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('contract_create')
    end

    it 'extending a contract' do
      @contract = FactoryGirl.create(:contract, chair: @chair, hiwi: @user)
      attributes = @contract.attributes
      attributes['end_date'] = attributes['end_date'] >> 1
      patch :update, id: @contract.id , contract: attributes

      expect(Event.all.count).to eq(1)
      expect(Event.first.type).to eq('contract_extend')
    end
  end
end
