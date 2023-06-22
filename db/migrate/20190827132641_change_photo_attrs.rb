class ChangePhotoAttrs < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :eq_id, :integer
    add_column :photos, :zone_id, :integer
  end
end
