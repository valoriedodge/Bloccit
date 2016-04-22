class Comment < ActiveRecord::Base
  belongs_to :user
  has_many :commentings
  has_many :topics, through: :commentings, source: :commentable, source_type: :Topic
  # #5
  has_many :posts, through: :commentings, source: :commentable, source_type: :Post
  
  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true
end
