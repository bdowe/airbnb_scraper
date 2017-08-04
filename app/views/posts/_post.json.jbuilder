json.extract! post, :id, :heading, :price, :housing, :beds, :reviews, :timestamp, :created_at, :updated_at
json.url post_url(post, format: :json)
