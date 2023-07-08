class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.references :dashboard, null: false, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
