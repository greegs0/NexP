FactoryBot.define do
  factory :bookmark do
    association :user
    association :bookmarkable, factory: :post

    trait :project_bookmark do
      association :bookmarkable, factory: :project
    end
  end
end
