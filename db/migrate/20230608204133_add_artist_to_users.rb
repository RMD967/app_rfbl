class AddArtistToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :artist, :boolean, default: false
  end
end
