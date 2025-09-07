class CreateSleepRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :slept_at, null: false
      t.datetime :woke_at
      t.timestamps
    end

    add_index :sleep_records, [ :user_id, :created_at ]
    add_index :sleep_records, [ :user_id, :slept_at ]
    add_index :sleep_records, :woke_at
  end
end
