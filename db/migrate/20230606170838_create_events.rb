class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.date :date
      t.integer :duration
      t.string :genre
      t.string :location
      t.string :time

      t.timestamps
    end
  end
end
