class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :url, null: false

      t.timestamps
    end
    add_index :sites, :code,                unique: true
  end
end
