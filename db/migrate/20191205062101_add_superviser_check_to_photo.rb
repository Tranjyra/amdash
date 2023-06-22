class AddSuperviserCheckToPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :checked, :boolean
  end
end
