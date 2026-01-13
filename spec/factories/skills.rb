FactoryBot.define do
  factory :skill do
    sequence(:name) { |n| "Skill #{n}" }
    category { Skill::CATEGORIES.sample }

    trait :backend do
      category { 'Backend' }
    end

    trait :frontend do
      category { 'Frontend' }
    end

    trait :database do
      category { 'Database' }
    end
  end
end
