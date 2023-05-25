FactoryBot.define do
  factory :task do
    title { 'テスト' }
    body { 'テスト' }
  end

  factory :task_without_title do
    title { '' }
    body { 'テスト' }
  end
end
