require 'rails_helper'

RSpec.describe CategoriesController, type: :request do
  describe 'GET #index' do
    it '適切なステータスコードが返ってくること' do
      get categories_path
      expect(response).to have_http_status 200
    end

    let!(:category1) { create(:category, title: 'Example Category') }

    it 'データが存在する場合、一致するレコードを表示すること' do
      get categories_path, params: { search: 'Example' }
      expect(response.body).to include(category1.title)
    end

    it '一致するデータが存在しない場合、レコードを表示しないこと' do
      get categories_path, params: { search: 'Nonexistent' }
      expect(response.body).not_to include(category1.title)
    end
  end

  describe 'GET #show' do
    let(:category) { create(:category) }

    it '適切なステータスコードが返ってくること' do
      get category_path(category)
      expect(response).to have_http_status 200
    end

    it '404ステータスが返ること' do
      get category_path(0)
      expect(response).to have_http_status 404
    end
  end

  describe 'GET #new' do
    it '適切なステータスコードが返ってくること' do
      get new_category_path
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #edit' do
    let(:category) { create(:category) }

    it '適切なステータスコードが返ってくること' do
      get edit_category_path(category)
      expect(response).to have_http_status 200
    end
  end

  describe 'POST #create' do
    subject { post categories_path, params: category_params }
    context '正常系' do
      let(:category_params) { { category: { title: 'test' } } }

      it '適切なステータスコードが返ってくること' do
        subject
        expect(response).to have_http_status 302
      end

      it 'レコードがひとつ増えること' do
        expect { subject }.to change(Category, :count).by(1)
      end

      it '作成されたレコードの値が意図したものになっていること' do
        subject
        expect(category_params[:category][:title]).to eq (Category.last.title)
      end

      it 'redirect 先が正しいこと' do
        subject
        expect(response).to redirect_to(categories_path)
      end
    end

    context '異常系' do
      let(:category_params) { { category: { title: '' } } }

      it '適切なステータスコードが返ってくること' do
        subject
        expect(response).to have_http_status 422
      end

      it 'レコードが増えないこと' do
        expect { subject }.to_not change(Category, :count)
      end

      it 'render 先が正しいこと' do
        subject
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch category_path(category), params: category_params }
    context '正常系' do
      let(:category) { create(:category) }
      let(:category_params) { { category: { title: 'test update' } } }

      it '適切なステータスコードが返ってくること' do
        subject
        expect(response).to have_http_status 302
      end

      it 'レコードの値が意図した値に更新されていること' do
        subject
        expect(category.reload.title).to eq('test update')
      end

      it 'redirect 先が正しいこと' do
        subject
        expect(response).to redirect_to(categories_path)
      end
    end

    context '異常系' do
      let(:category) { create(:category) }
      let(:category_params) { { category: { title: '' } } }

      it '適切なステータスコードが返ってくること' do
        subject
        expect(response).to have_http_status 422
      end

      it 'レコードが更新されないこと' do
        subject
        expect(category.reload.title).to eq('テスト')
      end

      it 'render 先が正しいこと' do
        subject
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete category_path(category) }
    let!(:category) { create(:category) }

    it '適切なステータスコードが返ってくること' do
      subject
      expect(response).to have_http_status 302
    end

    it 'レコードがひとつ減ること' do
      expect { subject }.to change(Category, :count).by(-1)
    end

    it 'redirect 先が正しいこと' do
      subject
      expect(response).to redirect_to(categories_path)
    end
  end
end
