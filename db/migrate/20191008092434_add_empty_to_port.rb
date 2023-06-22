class AddEmptyToPort < ActiveRecord::Migration[5.2]
  def change
    add_column :ports, :empty, :boolean, default: false
  end
end
