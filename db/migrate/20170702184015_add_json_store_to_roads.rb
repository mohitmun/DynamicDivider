class AddJsonStoreToRoads < ActiveRecord::Migration
  def change
    add_column :roads, :json_store, :json
  end
end
