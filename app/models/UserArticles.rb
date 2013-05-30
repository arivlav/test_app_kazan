class UserArticles < ActiveRecord::Base
  attr_accessible :user_id, :articles_id
end
