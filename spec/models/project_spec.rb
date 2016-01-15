require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:project)).to be_valid
  end

  before(:each) do
    @project = FactoryGirl.create(:project)
    @project.users << FactoryGirl.create(:user)
    @project.users << FactoryGirl.create(:user)
    @project.users << FactoryGirl.create(:wimi, chair_id: @project.chair.id).user
    @project.users << FactoryGirl.create(:wimi, chair_id: @project.chair.id).user
  end

  it 'lists all wimis of a project' do
    expect(@project.wimis.size).to eq(2)
  end


  it 'lists all hiwis of a project' do
    expect(@project.hiwis.size).to eq(2)
  end
end