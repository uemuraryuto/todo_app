require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { create(:category) }

  describe 'validations' do
    context '正常系' do
      it 'バリデーションエラーが出ないこと' do
        expect(category.valid?).to eq true
      end
    end

    context '異常系' do
      it 'タイトルが空のときバリデーションエラーが出ること' do
        category.title = nil
        expect(category.valid?).to eq false
      end
    end
  end
end
