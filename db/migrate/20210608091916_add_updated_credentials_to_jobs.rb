class AddUpdatedCredentialsToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :islatest, :integer, default:0
  end
end
