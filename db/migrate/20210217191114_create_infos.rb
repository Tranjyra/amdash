class CreateInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :infos do |t|
      t.integer :category_id
      t.integer :subcategory_id
      t.integer :base_type
      t.string :name
      t.string :desc
      t.string :source_url
      t.string :source_type
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
