class CreatePatchPanels < ActiveRecord::Migration[5.2]
  def change
    create_table :patch_panels do |t|
      t.integer :job_id

      t.timestamps
    end
  end
end
