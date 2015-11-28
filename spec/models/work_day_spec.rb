require 'rails_helper'
require 'spec_helper'

describe WorkDay, type: :model do

    it "has a valid factory" do
      FactoryGirl.create(:work_day).should be_valid
    end

    it "is invalid without a date"
    it "is invalid without a user_id"
    it "is invalid without a start_time"
    it "is invalid without a break"
    it "is invalid without an end_time"

end
