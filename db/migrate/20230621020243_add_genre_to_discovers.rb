class AddGenreToDiscovers < ActiveRecord::Migration[7.0]
  def change
    add_column :discovers, :genre, :string
  end
end
