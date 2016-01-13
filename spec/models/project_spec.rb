# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :string           default("")
#  public         :boolean          default(TRUE)
#  status         :boolean          default(TRUE)
#  chair_id       :integer
#  project_leader :string           default("")
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  it "can return all wimis in an unique array" do
    chair = FactoryGirl.create(:chair)
    project = FactoryGirl.create(:project)
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    user3 = FactoryGirl.create(:user)
    chair_wimi1 = FactoryGirl.create(:chair_wimi, application: 'accepted', user: user1, chair: chair)
    chair_wimi2 = FactoryGirl.create(:chair_wimi, application: 'accepted', user: user2, chair: chair)
    project.users << user1
    project.users << user2
    project.users << user3

    expect(project.wimis).to eq [user1, user2]
  end
end
