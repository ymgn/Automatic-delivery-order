class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :order_list_id, null: false
      t.string :item_id, null: false
      t.integer :item_num, null: false
      t.boolean :order_flag, null: false
      t.timestamps
    end
  end
end
