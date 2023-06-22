class PortsController < ApplicationController
  before_action :set_patch_panel
  before_action :set_job
  before_action :set_port, only: [:edit, :update]
  def new
    @port = Port.new
    respond_to do |format|
      format.html
      format.js
    end
  end
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @port.update(port_params)
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  private
  def set_patch_panel
    @patch_panel = PatchPanel.find(params[:patch_panel_id])
  end
  def set_job
    @job = @patch_panel.job
  end
  def set_port
    @port = Port.find(params[:id])
  end
  def port_params
    params.require(:port).permit(:patch_panel_id, :comment, :short_description, :eq_id, :zone_id, :used, :empty)
  end
end
