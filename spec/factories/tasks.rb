FactoryBot.define do
  factory :task do
    user

    sequence(:title) { |n| "Test title #{n}" }
    sequence(:content) { |n| "Test content #{n}" }
    status { %i[todo doing done].sample }
    deadline { 1.week.after }
  end
end
