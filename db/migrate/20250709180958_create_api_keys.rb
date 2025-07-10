class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :api_keys do |t|
      t.uuid :owner, null: false, unique: true
      t.string :digest, null: false
      t.timestamps
    end

    create_table :secure_keys do |t|
      t.string :owning_service, null: false
      t.string :digest, null: false
      t.timestamps
    end
    add_index :api_keys, :digest, unique: true
    add_index :secure_keys, :digest, unique: true
  end
end
