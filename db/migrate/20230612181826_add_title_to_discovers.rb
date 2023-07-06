class AddTitleToDiscovers < ActiveRecord::Migration[7.0]
  def change
    add_column :discovers, :title, :string
  end
end
