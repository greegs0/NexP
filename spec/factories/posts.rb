FactoryBot.define do
  factory :post do
    association :user
    content { Faker::Lorem.paragraph(sentence_count: 3) }
    likes_count { 0 }
    comments_count { 0 }

    trait :with_likes do
      after(:create) do |post|
        create_list(:like, 3, post: post)
      end
    end

    trait :with_comments do
      after(:create) do |post|
        create_list(:comment, 5, post: post)
      end
    end
  end
end
