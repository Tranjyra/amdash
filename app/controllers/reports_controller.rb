class ReportsController < ApplicationController
  def jobs_all
    respond_to do |format|
      format.csv {send_data Job.to_csv, filename: "Jobs-#{Date.today}.csv"}
    end

  end
end
