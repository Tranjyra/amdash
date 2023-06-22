class StaffController < ApplicationController
  def index
    @staff = Staff.all
    @staff = @staff.where(zone_id: params[:zone_id]) if params[:zone_id]
    respond_to do |format|
      format.json { render json: @staff }
      format.js
      format.html
    end
  end
end
