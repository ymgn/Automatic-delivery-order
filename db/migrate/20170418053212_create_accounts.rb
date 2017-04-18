class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :user_id
      t.string :site_id
      t.string :mail
      t.string :password_digest

      t.timestamps
    end
  end
end
