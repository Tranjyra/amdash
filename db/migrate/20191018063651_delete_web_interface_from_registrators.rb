class DeleteWebInterfaceFromRegistrators < ActiveRecord::Migration[5.2]
  def change
    remove_column :registrators, :web_interface
  end
end
