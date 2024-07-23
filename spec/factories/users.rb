# spec/factories/users.rb
FactoryBot.define do
    factory :user do
      sequence(:name) { |n| "User#{n}" }
      sequence(:email) { |n| "user#{n}@example.com" }
      password { 'password' }
      password_confirmation { 'password' }
  
      trait :admin do
        admin { true }
      end
  
      trait :general do
        admin { false }
      end
    end
  end
  