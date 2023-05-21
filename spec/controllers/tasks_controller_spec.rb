require 'rails_helper'

RSpec.describe TasksController, type: :request do
  describe 'GET #index' do
    it '適切なステータスコードが返ってくること' do
      get root_path
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #show' do
    let(:task) { create(:task) }
    it '適切なステータスコードが返ってくること' do
      get task_path(task)
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #new' do
    it '適切なステータスコードが返ってくること' do
      get new_task_path
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #edit' do
    let(:task) { create(:task) }
    it '適切なステータスコードが返ってくること' do
      get edit_task_path(task)
      expect(response).to have_http_status 200
    end
  end

  describe 'POST #create' do
    subject { post tasks_path, params: task_params }
    context '正常系' do
      let(:task_params) { { task: { title: 'test', body: 'test' } } }
      it '適切なステータスコードが返ってくること' do
        subject
        expect(response).to have_http_status 302
      end
      it 'レコードがひとつ増えること' do
        expect { subject }.to change(Task, :count).by(1)
      end
      it '作成されたレコードの値が意図したものになっていること' do
        subject
        expect(task_params[:task][:title]).to eq (Task.last.title)
      end
      it 'redirect 先が正しいこと' do
        subject
        expect(response).to redirect_to(root_path)
      end
    end

    context '異常系' do
      let(:task_params) { { task: { title: '', body: '' } } }
      it '適切なステータスコードが返ってくること' do
        subject
        expect(response).to have_http_status 422
      end
      it 'レコードが増えないこと' do
        expect { subject }.to_not change(Task, :count)
      end
      it 'render 先が正しいこと' do
        subject
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch task_path(task), params: task_params }
    context '正常系' do
      let(:task) { create(:task) }
      let(:task_params) { { task: { title: 'test update', body: 'test update' } } }
      it '適切なステータスコードが返ってくること' do
        subject
        expect(response).to have_http_status 302
      end
      it 'レコードの値が意図した値に更新されていること' do
        subject
        expect(task.reload.title).to eq('test update')
      end
      it 'redirect 先が正しいこと' do
        subject
        expect(response).to redirect_to(root_path)
      end
    end

    context '異常系' do
      let(:task) { create(:task) }
      let(:task_params) { { task: { title: '', body: '' } } }
      it '適切なステータスコードが返ってくること' do
        subject
        expect(response).to have_http_status 422
      end
      it 'レコードが更新されないこと' do
        subject
        expect(task.reload.title).to eq('テスト')
      end
      it 'render 先が正しいこと' do
        subject
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete task_path(task) }
    let!(:task) { create(:task) }
    it '適切なステータスコードが返ってくること' do
      subject
      expect(response).to have_http_status 302
    end
    it 'レコードがひとつ減ること' do
      expect { subject }.to change(Task, :count).by(-1)
    end
    it 'redirect 先が正しいこと' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
