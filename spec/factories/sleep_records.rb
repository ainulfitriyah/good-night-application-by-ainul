FactoryBot.define do
  factory :sleep_record do
    association :user
    slept_at { DateTime.now - 8.hours }
    woke_at { DateTime.now }
  end
end
