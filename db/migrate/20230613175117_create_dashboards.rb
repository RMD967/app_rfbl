class CreateDashboards < ActiveRecord::Migration[7.0]
  def change
    create_table :dashboards do |t|
      t.string :artist_genre
      t.integer :artist_count
      t.string :artist_name
      t.string :artist_instrument
      t.string :artist_location
      t.boolean :artist_travel
      t.float :artist_radius
      t.string :artist_cities

      t.timestamps
    end
  end
end
