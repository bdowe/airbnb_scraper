class AddExternalUrlToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :external_url, :string
  end
end
