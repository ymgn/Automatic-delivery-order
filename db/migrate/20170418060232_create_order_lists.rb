class CreateOrderLists < ActiveRecord::Migration[5.0]
  def change
    create_table :order_lists do |t|
      t.string :account_id, null: false
      t.string :order_token, null: false
      t.integer :sort_num, null: false

      t.timestamps
    end
    add_index :order_lists, :order_token,                unique: true
  end
end
