class CreateRegistrators < ActiveRecord::Migration[5.2]
  def change
    create_table :registrators do |t|
      t.integer :job_id

      t.timestamps
    end
  end
end
