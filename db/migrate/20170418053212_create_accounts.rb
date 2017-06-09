class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.integer :user_id, null: false
      t.integer :site_id, null: false
      t.string :code, null: false
      t.string :email, null: false
      t.string :password, null: false

      t.timestamps
    end
  end
end
