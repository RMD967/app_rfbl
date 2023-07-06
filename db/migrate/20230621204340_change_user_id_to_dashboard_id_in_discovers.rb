class ChangeUserIdToDashboardIdInDiscovers < ActiveRecord::Migration[7.0]
  def change
    rename_column :discovers, :user_id, :dashboard_id
  end
end
