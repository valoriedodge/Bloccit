class Topic < ActiveRecord::Base
    has_many :posts, dependent: :destroy
    has_many :comments, as: :commentable
    has_many :labelings, as: :labelable
    has_many :labels, through: :labelings
end
