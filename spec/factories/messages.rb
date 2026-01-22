# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    association :sender, factory: :user
    association :project
    content { Faker::Lorem.sentence }
    read_at { nil }

    trait :read do
      read_at { Time.current }
    end

    trait :long_content do
      content { Faker::Lorem.characters(number: 500) }
    end
  end
end
