FactoryBot.define do
  factory :notification do
    association :user
    association :actor, factory: :user
    association :notifiable, factory: :post
    action { 'like' }
    read { false }

    trait :read do
      read { true }
    end

    trait :follow_notification do
      action { 'follow' }
    end

    trait :comment_notification do
      action { 'comment' }
    end
  end
end
