class Post < ActiveRecord::Base
	attr_accessible :body, :approved, :likes, :dislikes

	validates_presence_of :body
end
