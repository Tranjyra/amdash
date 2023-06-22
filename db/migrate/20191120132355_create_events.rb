class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :serialized_subject
      t.integer :event_type
      t.integer :from_user_id

      t.timestamps
    end
  end
end
