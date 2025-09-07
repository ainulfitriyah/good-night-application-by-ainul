class SleepRecord < ApplicationRecord
  belongs_to :user

  scope :active, -> { where(woke_at: nil) }
end
