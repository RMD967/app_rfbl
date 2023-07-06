class AddArtistDescriptionAndPriceToDashboards < ActiveRecord::Migration[7.0]
  def change
    add_column :dashboards, :artist_description, :text
    add_column :dashboards, :artist_price, :decimal, precision: 8, scale: 2
  end
end
