class AddUpdatedCredentialsToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :subjob_id, :integer
    add_column :photos, :status, :integer
  end
end
