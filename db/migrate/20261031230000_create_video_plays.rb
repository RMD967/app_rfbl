class CreateVideoPlays < ActiveRecord::Migration[7.0]
  def change
    create_table :video_plays do |t|
      t.references :discover, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.string :ip_address
      t.float :duration, default: 0.0

      t.timestamps
    end

    add_index :video_plays, [:discover_id, :user_id], unique: true, where: "user_id IS NOT NULL", name: "idx_unique_user_video_play"
    add_index :video_plays, [:discover_id, :ip_address], unique: true, where: "user_id IS NULL", name: "idx_unique_guest_video_play"
  end
end
