FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "TEST#{n}@example.com" }
    password { 'secret' }
    password_confirmation { 'secret' }
  end
end
