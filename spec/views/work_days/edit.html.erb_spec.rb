require 'rails_helper'

RSpec.describe 'work_days/edit.html.erb', type: :view do
  before(:each) do
    @work_day = assign(:work_day, WorkDay.create!(
      :date => '11-11-2015',
      :start_time => Date.today.beginning_of_day,
      :brake => 30,
      :end_time => Date.today.end_of_day,
      :attendance => 'K',
      :notes => 'MyString'
    ))
  end

  it 'displays \'Notes\' field on edit page' do
    render
  end
end
