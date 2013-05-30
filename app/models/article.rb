class Article < ActiveRecord::Base
  attr_accessible :content, :rating, :title, :user_id
  belongs_to :user
  default_scope { order('rating DESC', 'created_at DESC') }
 validates_presence_of :content, :title, :message => "can't be empty"
end
