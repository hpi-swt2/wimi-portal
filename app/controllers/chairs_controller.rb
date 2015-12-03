class ChairsController < ApplicationController
  before_action :set_chair, only: [:show]

  def index
    @chairs = Chair.all
  end

  def show
    @requests = @chair.wimis.where(:application => 'pending')
    # Das muss auf jeden Fall noch anders gemacht werden:
    @wimis = []
    @chair.users.each do |w|
      if w.is_wimi?
        @wimis.push w
      end
    end




    #@wimis = @chair.users.where(:is_wimi? => true)
    #@hiwis = @chair.projects.users.where(:is_hiwi => false)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chair
      @chair = Chair.find(params[:id])
    end
end
