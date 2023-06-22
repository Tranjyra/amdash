class PatchPanelsController < ApplicationController
  before_action :set_job_patch_panel
  before_action :set_store
  before_action :set_path_panel, only: [:destroy]
  def index
    if !@job.patch_panel.nil?
      redirect_to job_patch_panel_path(@job, @job.patch_panel)
    else
      redirect_to new_job_patch_panel_path
    end
  end
  def new
    @patch_panel = PatchPanel.init(@job.id)
    respond_to do |format|
      format.js
      format.html
    end
  end
  def destroy
    if @patch_panel.destroy
      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  private
    def set_job_patch_panel
      @job = Job.find(params[:job_id])
    end
    def set_store
      @store = @job.store
    end
    def set_path_panel
      @patch_panel = PatchPanel.find(params[:id])
    end
end
