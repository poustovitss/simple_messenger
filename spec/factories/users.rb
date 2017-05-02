FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    password 'changeme'
    password_confirmation 'changeme'

    trait :admin do
      role :admin
    end
  end
end
