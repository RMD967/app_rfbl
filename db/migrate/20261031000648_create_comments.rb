class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :discover, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :comments }
      t.text :content, null: false

      t.timestamps
    end
  end
end
