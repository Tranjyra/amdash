class AddSupervisedToStaff < ActiveRecord::Migration[5.2]
  def change
    add_column :staffs, :supervised, :boolean
  end
end
