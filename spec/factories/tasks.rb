FactoryBot.define do
  factory :task do
    user

    sequence(:title) { |n| "Test title #{n}" }
    sequence(:content) { |n| "Test content #{n}" }
    status { :todo }
    deadline { 1.week.after }
  end
end
