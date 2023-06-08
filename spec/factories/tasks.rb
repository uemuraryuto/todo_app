FactoryBot.define do
  factory :task do
    title { 'テスト' }
    body { 'テスト' }
    deadline_on { Date.tomorrow }
  end
end
