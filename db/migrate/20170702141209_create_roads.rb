class CreateRoads < ActiveRecord::Migration
  def change
    create_table :roads do |t|
      t.text :name
      t.float :width
      t.float :length

      t.timestamps null: false
    end
  end
end
