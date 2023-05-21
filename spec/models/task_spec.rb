require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'バリデーションチェック' do
    task = Task.new(title: nil)
    expect(task.valid?).to eq false
  end
end
