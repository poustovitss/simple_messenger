FactoryGirl.define do
  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email Faker::Internet.email
    password 'changeme'
    password_confirmation 'changeme'
    role :user

    trait :admin do
      role :admin
    end
  end
end
