FactoryBot.define do
  factory :comment do
    association :user
    association :post
    content { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end
