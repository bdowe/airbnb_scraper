class RemoveTimestampFromPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :timestamp, :string
  end
end
