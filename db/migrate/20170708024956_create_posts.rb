class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :heading
      t.decimal :price
      t.string :housing
      t.integer :beds
      t.integer :reviews
      t.string :timestamp

      t.timestamps
    end
  end
end
