class ChangeDateAndTimeToDateTimeInEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :date, :date
    remove_column :events, :time, :string
    add_column :events, :datetime, :datetime
  end
end
