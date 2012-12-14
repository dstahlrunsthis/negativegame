class ApplicationController < ActionController::Base
 	protect_from_forgery

 	helper_method :liked_posts

 	def liked_posts
        (session[:liked_posts] ||= {})
    end
end


