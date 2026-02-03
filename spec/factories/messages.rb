# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    association :sender, factory: :user
    content { Faker::Lorem.sentence }
    read_at { nil }

    # Par défaut, message direct (pas de projet)
    project { nil }
    association :recipient, factory: :user

    trait :read do
      read_at { Time.current }
    end

    trait :long_content do
      content { Faker::Lorem.characters(number: 500) }
    end

    trait :project_message do
      association :project
      recipient { nil }
    end
  end
end
