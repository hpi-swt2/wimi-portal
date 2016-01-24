class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @time_sheet = TimeSheet.new
  end

  def edit
  end

  def hand_in
    TimeSheet.find(params[:id]).update(status: 'pending', handed_in: true, hand_in_date: Date.today)
    redirect_to user_path(current_user)
  end

  def accept
    TimeSheet.find(params[:id]).update(status: 'accepted', last_modified: Date.today, signer: current_user.id)
    redirect_to user_path(current_user)
  end

  def reject
    TimeSheet.find(params[:id]).update(status: 'rejected', handed_in: false, last_modified: Date.today, signer: current_user.id)
    redirect_to user_path(current_user)
  end

  def update
    if @time_sheet.update(time_sheet_params)
      flash[:success] = 'Time Sheet was successfully updated.'
      redirect_to work_days_path(month: @time_sheet.month, year: @time_sheet.year, project: @time_sheet.project)
    else
      render :edit
    end
  end

  private

  def set_time_sheet
    @time_sheet = TimeSheet.find(params[:id])
  end

  def time_sheet_params
    params[:time_sheet].permit(TimeSheet.column_names.map(&:to_sym))
  end
end
