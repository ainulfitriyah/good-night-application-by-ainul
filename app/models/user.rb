class User < ApplicationRecord
  has_many :sleep_records, dependent: :destroy
  has_many :followings, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, class_name: "Follow", foreign_key: "followee_id", dependent: :destroy

  def following?(target_user)
    followings.exists?(followee_id: target_user.id)
  end
  def follow(target_user)
    followings.create(followee_id: target_user.id)
  end
end
