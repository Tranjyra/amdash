class CreateTestArs < ActiveRecord::Migration[5.2]
  def change
    create_table :test_ars do |t|
      t.string :name

      t.timestamps
    end
  end
end
