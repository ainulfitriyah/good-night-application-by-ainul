class User < ApplicationRecord
  has_many :sleep_records, dependent: :destroy
  has_many :followings, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, class_name: "Follow", foreign_key: "followee_id", dependent: :destroy

  has_many :following_users, through: :followings, source: :followee
  has_many :following_sleep_records, through: :following_users, source: :sleep_records

  def following?(target_user)
    followings.exists?(followee_id: target_user.id)
  end
  def follow(target_user)
    followings.create(followee_id: target_user.id)
  end

  def unfollow(target_user)
    followings.find_by(followee_id: target_user.id)&.destroy
  end
end
