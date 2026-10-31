class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :actor, foreign_key: { to_table: :users }
      t.string :action_type, null: false
      t.references :notifiable, polymorphic: true
      t.string :title
      t.text :content
      t.string :target_url
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, [:recipient_id, :read_at]
    add_index :notifications, [:recipient_id, :action_type]
  end
end
