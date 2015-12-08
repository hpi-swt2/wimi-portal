class TimeSheet < ActiveRecord::Base
    belongs_to :user
    belongs_to :project

  def show_add_signature_prompt
    flash[:error] = 'Please add signature'
  end
end
