class AddReportToStaff < ActiveRecord::Migration[5.2]
  def change
    add_column :staffs, :report_id, :integer
  end
end
