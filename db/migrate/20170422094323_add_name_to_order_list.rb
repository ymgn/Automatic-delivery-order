class AddNameToOrderList < ActiveRecord::Migration[5.0]
  def change
    add_column :order_lists, :name, :string
  end
end
