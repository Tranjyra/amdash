class CreatePorts < ActiveRecord::Migration[5.2]
  def change
    create_table :ports do |t|
      t.integer :patch_panel_id
      t.integer :port_number
      t.integer :zone_id
      t.integer :eq_id
      t.string :comment

      t.timestamps
    end
  end
end
