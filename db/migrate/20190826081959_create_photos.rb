class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.integer :job_id
      t.integer :staff_id
      t.string :comment

      t.timestamps
    end
  end
end
