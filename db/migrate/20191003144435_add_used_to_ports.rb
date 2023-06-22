class AddUsedToPorts < ActiveRecord::Migration[5.2]
  def change
    add_column :ports, :used, :boolean, null: false
  end
end
