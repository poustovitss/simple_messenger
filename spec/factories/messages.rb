FactoryGirl.define do
  factory :message do
    body Faker::Lorem.sentence
    conversation_id 10
    user_id 1
  end
end
