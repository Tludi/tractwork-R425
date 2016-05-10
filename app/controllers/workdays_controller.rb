# workdays_controller.rb
class WorkdaysController < ApplicationController
  before_action :set_workday, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index]
  before_action :check_for_todays_workday, only: [:show]
  before_action :get_timePunches, only: [:new, :edit]
  skip_before_filter :verify_authenticity_token, only: [:create]

  # GET /workdays
  # GET /workdays.json
  def index
    @user = current_user
    @workdays = current_user.workdays
    # render json: @workdays
    # render @workdays
  end

  # GET /workdays/1
  # GET /workdays/1.json
  def show
    @current_time = get_current_time

    @time_punch = TimePunch.new
    @latest_time_punch = @workday.timePunches.last
    @time_punch_status = @latest_time_punch.clockedInStatus if @latest_time_punch
    @current_workday_time_punches = @workday.timePunches

    @current_project = Project.find(@workday.project.id)
    @hours_worked = Workday.calculate_workhours(@workday)
    @hours_saved = @workday.hoursWorked
  end

  # GET /workdays/new
  def new
    @current_user_workdays = current_user.workdays
    # check to see if current workday exists
    @current_user_workdays.each do |wd|
      if wd.dayDate == Date.today
        redirect_to edit_workday_path(wd)
      else
        @workday = Workday.new
      end
    end


  end

  # GET /workdays/1/edit
  def edit
    @time_punch = TimePunch.new
  end

  # POST /workdays
  # POST /workdays.json
  def create
    @workday = Workday.new(workday_params)

    respond_to do |format|
      if @workday.save
        format.html { redirect_to @workday, notice: 'Workday was successfully created.' }
        format.json { render :show, status: :created, location: @workday }
      else
        format.html { render :new }
        format.json { render json: @workday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workdays/1
  # PATCH/PUT /workdays/1.json
  def update
    respond_to do |format|
      if @workday.update(workday_params)
        format.html { redirect_to dashboard_path, notice: 'Workday was successfully updated.' }
        format.json { render :show, status: :ok, location: @workday }
      else
        format.html { render :edit }
        format.json { render json: @workday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workdays/1
  # DELETE /workdays/1.json
  def destroy
    @workday.destroy
    respond_to do |format|
      format.html { redirect_to workdays_url, notice: 'Workday was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_workday
    @workday = Workday.find(params[:id])
  end


  def check_for_todays_workday
    @user_workdays = current_user.workdays
    @current_workday = nil
    @user_workdays.each do |wd|
      if wd.dayDate == Time.zone.today
        @current_workday = wd
      end
    end

    if @current_workday == nil
      @current_workday = Workday.createCurrentWorkday(current_user)
    end
  end


  def get_timePunches
    @userWorkdays = current_user.workdays
    @userWorkdays.each do |wd|
      if wd.dayDate == Time.zone.today
        @currentUserWorkDay = wd
        @timePunches = @currentUserWorkDay.timePunches
      end
    end

  end

  def set_user
    @current_user = current_user
  end

  def get_current_time
    Time.zone.today
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def workday_params
    params.require(:workday).permit(:hoursWorked, :user_id, :dayDate, :project_id, :notes, :timePunches => [:entry, :workday_id, :clockedInStatus])
  end
end
