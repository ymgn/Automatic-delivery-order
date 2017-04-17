class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.string :site_id
      t.string :site_name
      t.string :url

      t.timestamps
    end
  end
end
