class AddTimestampToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :timestamp, :timestamp
  end
end
