class RemoveForeignKeyFromDiscovers < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :discovers, :users
    add_foreign_key :discovers, :dashboards, column: :dashboard_id
  end
end
