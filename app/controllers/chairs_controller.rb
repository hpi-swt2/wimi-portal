class ChairsController < ApplicationController
  before_action :set_chair, only: [:show, :edit, :update, :destroy]

  # GET /chairs
  # GET /chairs.json
  def index
    @chairs = Chair.all
  end

  # GET /chairs/1
  # GET /chairs/1.json
  def show
  end

  # GET /chairs/new
  def new
    @chair = Chair.new
  end

  # GET /chairs/1/edit
  def edit
  end

  # POST /chairs
  # POST /chairs.json
  def create
    @chair = Chair.new(chair_params)

    respond_to do |format|

      if (params[:admin_user] == "null") || (params[:representative_user] == "null")
        format.html { redirect_to new_chair_path, alert: 'You have to set an admin and representative!' }
        format.json { render json: @chair.errors, status: :unprocessable_entity }
      else
        if @chair.save

          tmp_user = User.find(params[:admin_user])
          unless @chair.admins.include? (tmp_user)
            ChairAdmin.create(:user_id => params[:admin_user], :chair_id => @chair.id)
          end

          tmp_user = User.find(params[:representative_user])
          unless @chair.representatives.include? (tmp_user)
            ChairRepresentative.create(:user_id => params[:representative_user], :chair_id => @chair.id)
          end

          format.html { redirect_to chairs_path, notice: 'Chair was successfully created.' }
          format.json { render :show, status: :created, location: @chair }
        else
          format.html { render :new }
          format.json { render json: @chair.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /chairs/1
  # PATCH/PUT /chairs/1.json
  def update
    respond_to do |format|

      if (params[:admin_user] == "null") || (params[:representative_user] == "null")
        format.html { redirect_to edit_chair_path, alert: 'You have to set an admin and representative!' }
        format.json { render json: @chair.errors, status: :unprocessable_entity }
      else
        if @chair.update(chair_params)
          ChairAdmin.where(chair_id: @chair.id).destroy_all
          tmp_user = User.find(params[:admin_user])
          unless @chair.admins.include? (tmp_user)
            ChairAdmin.create(:user_id => params[:admin_user], :chair_id => @chair.id)
          end

          ChairRepresentative.where(chair_id: @chair.id).destroy_all
          tmp_user = User.find(params[:representative_user])
          unless @chair.representatives.include? (tmp_user)
            ChairRepresentative.create(:user_id => params[:representative_user], :chair_id => @chair.id)
          end

          format.html { redirect_to chairs_path, notice: 'Chair was successfully updated.' }
          format.json { render :show, status: :ok, location: @chair }
        else
          format.html { render :edit }
          format.json { render json: @chair.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /chairs/1
  # DELETE /chairs/1.json
  def destroy
    @chair.destroy
    respond_to do |format|
      format.html { redirect_to chairs_url, notice: 'Chair was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def apply
    logger.debug('Testlog')
    logger.debug(current_user.id)
    logger.debug(params[:chair])
    logger.debug('Testlog end')
    ChairsCandidate.create(:user_id => current_user.id, :chair_id => params[:chair])
  end
  # helper_method :apply

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chair
      @chair = Chair.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chair_params
      params.require(:chair).permit(:name)
    end
end
