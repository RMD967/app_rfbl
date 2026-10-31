class AddPostTypeToDiscovers < ActiveRecord::Migration[7.0]
  def change
    add_column :discovers, :post_type, :string, default: "music"
    add_index :discovers, :post_type
  end
end
