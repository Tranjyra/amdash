class AddReadedToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :readed, :boolean
  end
end
