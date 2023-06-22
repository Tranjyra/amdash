class AddRequiredToStaff < ActiveRecord::Migration[5.2]
  def change
    add_column :staffs, :required, :boolean
  end
end
