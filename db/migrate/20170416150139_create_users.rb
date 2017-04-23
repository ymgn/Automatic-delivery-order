class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login_id, null: false
    end
    add_index :users, :login_id,                unique: true
  end
end
