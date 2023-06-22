class RegistratorsController < ApplicationController
  before_action :set_job
  before_action :set_registrator, only: [:edit, :destroy, :update]

  def index; end

  def show; end

  def new
    @registrator = Registrator.new
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @registrator = Registrator.new(registrator_params)
    if @registrator.save
      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  def edit; end
  def update; end
  def destroy
    @registrator.destroy
    respond_to do |format|
      format.js
      format.html
    end
  end
  private

  def set_job
    @job = Job.find(params[:job_id])
    @store = @job.store
  end

  def set_registrator
    @registrator = Registrator.find(params[:id])
  end
  def registrator_params
    params.require(:registrator).permit(:job_id, :model_id, :cum_count, :ip_address )
  end
end
