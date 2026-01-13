FactoryBot.define do
  factory :team do
    association :user
    association :project
    role { 'member' }
    status { 'accepted' }
    joined_at { Time.current }
  end
end
