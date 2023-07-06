class CreateDiscovers < ActiveRecord::Migration[7.0]
  def change
    create_table :discovers do |t|
      t.text :content
      t.integer :likes
      t.integer :plays
      t.boolean :save
      t.decimal :start_time
      t.decimal :end_time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
