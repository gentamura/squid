class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  validates :user_id, presence: true
  validates :friend_id, presence: true
  scope :friends, ->(user) { where(user_id: user.id).or(where(friend_id: user.id)) }
  # scope :receivers, ->(user) { where(user_id: user.id).or(where(friend_id: user.id)).map { |f| f.user_id == user.id ? f.friend : f.user }  }
  # TODO : Need adjustments
  scope :receivers, ->(user) do
    where(user_id: user.id).or(where(friend_id: user.id)).map do |f|
      if f.user_id == user.id
        user.receivers.target << f.friend
      else
        user.receivers.target << f.user
      end
    end
  end
end
