class CreateTestModels < ActiveRecord::Migration[5.2]
  def change
    create_table :test_models do |t|
      t.string :name
      t.string :path

      t.timestamps
    end
  end
end
