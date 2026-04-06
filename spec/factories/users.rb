FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password              { '123456' }
    password_confirmation { '123456' }
    name                  { 'Test User' }
    role                  { 'staff' }

    trait :admin do
      role { 'admin' }
      sequence(:email) { |n| "admin#{n}@test.com" }
    end
  end
end
