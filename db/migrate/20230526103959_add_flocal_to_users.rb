class AddFlocalToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :flocal, :bool, default: false
  end
end
