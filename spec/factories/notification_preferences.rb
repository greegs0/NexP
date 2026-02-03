FactoryBot.define do
  factory :notification_preference do
    user { nil }
    notification_type { "MyString" }
    enabled { false }
    email_enabled { false }
  end
end
