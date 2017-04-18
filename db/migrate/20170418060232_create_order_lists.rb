class CreateOrderLists < ActiveRecord::Migration[5.0]
  def change
    create_table :order_lists do |t|
      t.string :account_id
      t.string :order_token
      t.integer :sort_num

      t.timestamps
    end
  end
end
