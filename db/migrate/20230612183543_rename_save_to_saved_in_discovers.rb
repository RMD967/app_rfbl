class RenameSaveToSavedInDiscovers < ActiveRecord::Migration[7.0]
  def change
    rename_column :discovers, :save, :saved
  end
end
