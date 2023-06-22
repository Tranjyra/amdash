class AddSupervisorToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :supervisor, :boolean
  end
end
