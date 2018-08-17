class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  validates :body, presence: true
  validates :user_id, presence: true

  acts_as_notifiable :users,
  targets: ->(comment,key) {
	   comment.user
  },
  tracked: true
end
