class Post < ApplicationRecord
	#Won't save values with the same heading
	validates :heading, presence: true, uniqueness: true
end
