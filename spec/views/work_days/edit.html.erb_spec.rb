require 'rails_helper'

RSpec.describe 'work_days/edit.html.erb', type: :view do
  before(:each) do
    @work_day = assign(:work_day, WorkDay.create!(
      :date => '11-11-2015',
      :start_time => Date.today.beginning_of_day,
      :break => 30,
      :end_time => Date.today.end_of_day,
      :attendance => 'K',
      :notes => 'MyString'
    ))
  end

  it 'renders the work_day form' do
    render

    assert_select 'form[action=?][method=?]', work_day_path(@work_day), 'post' do
        assert_select 'select#work_day_date_1i[name=?]', 'work_day[date(1i)]'
        assert_select 'select#work_day_date_2i[name=?]', 'work_day[date(2i)]'
        assert_select 'select#work_day_date_3i[name=?]', 'work_day[date(3i)]'

        assert_select 'select#work_day_start_time_4i[name=?]', 'work_day[start_time(4i)]'
        assert_select 'select#work_day_start_time_5i[name=?]', 'work_day[start_time(5i)]'

        assert_select 'input#work_day_break[name=?]', 'work_day[break]'

        assert_select 'select#work_day_end_time_4i[name=?]', 'work_day[end_time(4i)]'
        assert_select 'select#work_day_end_time_5i[name=?]', 'work_day[end_time(5i)]'

        assert_select 'select#work_day_attendance[name=?]', 'work_day[attendance]'
        assert_select 'input#work_day_notes[name=?]', 'work_day[notes]'
    end
  end
end
