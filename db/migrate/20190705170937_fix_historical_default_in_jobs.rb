class FixHistoricalDefaultInJobs < ActiveRecord::Migration[5.2]
  def change
    change_column :jobs, :historical, :boolean, default: false
  end
end
