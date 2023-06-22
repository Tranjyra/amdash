class AddHistoricalToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :historical, :boolean, default: false
  end
end
