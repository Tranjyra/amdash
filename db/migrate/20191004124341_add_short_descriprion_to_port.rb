class AddShortDescriprionToPort < ActiveRecord::Migration[5.2]
  def change
    add_column :ports, :short_description, :string
  end
end
