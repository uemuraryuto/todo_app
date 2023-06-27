require 'csv'

class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = Task.ransack(params[:q])
    @tasks = @q.result.not_done.page(params[:page])

    respond_to do |format|
      format.html
      format.csv do
        bom = "\uFEFF"
        csv_data = CSV.generate(bom) do |csv|
          csv_header = Task.column_names + ['category_titles'] - ['created_at', 'updated_at']
          csv << csv_header

          @tasks.each do |task|
            category_titles = task.categories.pluck(:title)
            csv << [task.id, task.title, task.body, task.deadline_on, task.status, task.priority, category_titles.to_json]
          end
        end

        send_data csv_data, filename: 'tasks.csv', type: 'text/csv'
      end
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = 'タスクの登録が完了しました'
      redirect_to root_path
    else
      flash.now[:alert] = 'タスクの登録に失敗しました'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = 'タスクの編集が完了しました'
      redirect_to root_path
    else
      flash.now[:alert] = 'タスクの編集に失敗しました'
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = 'タスクを削除しました'
      redirect_to root_path
    else
      flash.now[:alert] = 'タスクを削除できませんでした'
      render 'show'
    end
  end

  def import
    error_messages = Task.import(params[:file])
    if error_messages.any?
      flash[:error] = error_messages.join('\n')
    else
      flash[:success] = 'Import successful.'
    end
    redirect_to root_path
  end

    private
      def task_params
        params.require(:task).permit(:title, :body, :deadline_on, :status, :priority, category_ids: [])
      end

      def set_task
        @task = Task.find(params[:id])
      end
end
