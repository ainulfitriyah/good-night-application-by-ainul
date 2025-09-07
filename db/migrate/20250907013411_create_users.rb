class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.timestamps
    end

    add_index :users, :name
    add_index :users, [ :name, :created_at ], unique: true
  end
end
