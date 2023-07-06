class AddUserReferanceToDashboards < ActiveRecord::Migration[7.0]
  def change
    add_reference :dashboards, :user, null: false, foreign_key: true
  end
end
