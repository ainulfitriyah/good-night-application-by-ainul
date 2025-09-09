class AddDurationSecondsToSleepRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :sleep_records, :duration_seconds, :integer
    add_index :sleep_records, :duration_seconds
  end
end
