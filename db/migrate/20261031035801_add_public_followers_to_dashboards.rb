class AddPublicFollowersToDashboards < ActiveRecord::Migration[7.0]
  def change
    add_column :dashboards, :public_followers, :boolean, default: true, null: false
  end
end
