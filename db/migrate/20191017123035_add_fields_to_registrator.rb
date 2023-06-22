class AddFieldsToRegistrator < ActiveRecord::Migration[5.2]
  def change
    add_column :registrators, :model_id, :integer
    add_column :registrators, :cum_count, :integer
    add_column :registrators, :web_interface, :string
    add_column :registrators, :ip_address, :string
  end
end
