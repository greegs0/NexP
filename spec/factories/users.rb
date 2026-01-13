FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "user#{n}" }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { Faker::Name.name }
    bio { Faker::Lorem.sentence }
    zipcode { '75001' }
    experience_points { 0 }
    level { 1 }
    available { true }

    trait :with_skills do
      after(:create) do |user|
        create_list(:user_skill, 3, user: user)
      end
    end

    trait :unavailable do
      available { false }
    end

    trait :high_level do
      experience_points { 1000 }
      level { 11 }
    end
  end
end
