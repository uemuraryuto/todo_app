require 'rails_helper'

RSpec.describe Task, type: :model do

  describe 'validations' do
    context '正常系' do
      it 'バリデーションエラーが出ないこと' do
        expect(build(:task)).to be_valid
      end
    end

    context '異常系' do
      it 'タイトルが空のときバリデーションエラーが出ること' do
        expect(build(:task, title: '')).to be_invalid
      end
    end
  end
end
