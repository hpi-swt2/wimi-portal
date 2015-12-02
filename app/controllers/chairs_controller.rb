class ChairsController < ApplicationController
  def index
    @chairs = Chair.all
  end

  def apply
    wimi = Wimi.new(:chair_id => params[:chair])
    wimi.user = current_user
    wimi.application = 'pending'

    respond_to do |format|
      if wimi.save
        format.html { redirect_to chairs_path, notice: 'Chair wimi application was successfully created.' }
        format.json { render :show, status: :created, location: chairs_path }
      else
        format.html { redirect_to chairs_path, notice: 'Saving failed' }
        format.json { render json: chairs_path.errors, status: :unprocessable_entity }
      end
    end
  end
end
