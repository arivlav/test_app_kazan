class UserArticles < ActiveRecord::Base
  attr_accessible :articles_id, :user_id
end
