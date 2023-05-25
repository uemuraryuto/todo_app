require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { create(:task) }

  describe 'validations' do
    context '正常系' do
      it 'バリデーションエラーが出ないこと' do
        expect(task.valid?).to eq true
      end
    end

    context '異常系' do
      it 'タイトルが空のときバリデーションエラーが出ること' do
        task.title = nil
        expect(task.valid?).to eq false
      end
    end
  end
end
