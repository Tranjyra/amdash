class AddZoneIdToStaff < ActiveRecord::Migration[5.2]
  def change
    add_column :staffs, :zone_id, :integer
  end
end
