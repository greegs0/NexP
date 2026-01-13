FactoryBot.define do
  factory :project do
    association :owner, factory: :user
    sequence(:title) { |n| "Project #{n}" }
    description { Faker::Lorem.paragraph }
    status { 'open' }
    visibility { 'public' }
    max_members { 5 }
    current_members_count { 0 }

    trait :in_progress do
      status { 'in_progress' }
    end

    trait :completed do
      status { 'completed' }
    end

    trait :private do
      visibility { 'private' }
    end

    trait :full do
      max_members { 2 }
      current_members_count { 2 }
    end

    trait :with_skills do
      after(:create) do |project|
        create_list(:project_skill, 3, project: project)
      end
    end
  end
end
