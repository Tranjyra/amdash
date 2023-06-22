class FixStYffTypeInStaffs < ActiveRecord::Migration[5.2]
  def change
    rename_column :staffs, :styff_type, :staff_type
  end
end
