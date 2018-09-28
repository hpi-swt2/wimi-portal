require 'rails_helper'
require 'spec_helper'
require 'cancan/matchers'

describe 'project#show: invite someone unregistered to the project button' do
  before :each do
    @project = FactoryGirl.create(:project)
    @wimi = FactoryGirl.create(:wimi, chair: @project.chair).user
    @project.users << @wimi
    login_as @wimi
    visit project_path(@project)
  end

  context 'with a valid email' do
    before :each do
      @email = "test.example@student.hpi.uni-potsdam.de"
    end

    it 'creates a new user and adds them to the project' do
      find("#open-add-register-user").click
      within('#add-register-user-modal') do
        fill_in 'email', with: @email
        find("input[name='commit']").click
      end
      expect(@project.users.count).to eq(2)
      expect(Contract.count).to eq(0)
    end

    it 'creates a contract when the checkbox is ticked' do
      find("#open-add-register-user").click
      within('#add-register-user-modal') do
        fill_in 'email', with: @email
        check 'create_contract'
        find("input[name='commit']").click
      end
      expect(Contract.count).to eq(1)
    end
  end
end

