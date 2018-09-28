# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :string           default("")
#  status         :boolean          default(TRUE)
#  chair_id       :integer
#  project_leader :string           default("")
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { FactoryGirl.create(:project) }
  let(:wimi1) { FactoryGirl.create(:wimi, chair: project.chair).user }
  let(:wimi2) { FactoryGirl.create(:wimi, chair: project.chair).user }

  before(:example) do
    project.users << wimi1
    project.users << wimi2
  end

  it 'can return all wimis in an unique array' do
    expect(project.wimis).to eq [wimi1, wimi2]
  end

  it 'does not include wimis from other chairs in the .wimis array' do
    other_wimi = FactoryGirl.create(:wimi).user
    project.users << other_wimi

    expect(project.wimis).not_to include(other_wimi)
  end

  it 'has a valid factory' do
    expect(FactoryGirl.create(:project)).to be_valid
  end

  it 'lists all wimis of a project' do
    expect(project.wimis.size).to eq(2)
  end

  it 'lists all hiwis of a project' do
    project.users << FactoryGirl.create(:user)
    project.users << FactoryGirl.create(:user)
    expect(project.hiwis.size).to eq(2)
  end
end
