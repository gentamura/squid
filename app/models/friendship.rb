class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  validates :user_id, presence: true
  validates :friend_id, presence: true
  scope :friends, ->(user) { where(user_id: user.id).or(where(friend_id: user.id)) }
  scope :receiver_friends, ->(user) { friends(user).select { |f| f.user_id == user.id }.map(&:friend) }
end
