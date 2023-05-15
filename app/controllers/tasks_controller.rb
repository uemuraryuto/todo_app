class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice]='タスクの登録が完了しました'
      redirect_to root_path
    else
      flash.now[:alert]='タスクの登録に失敗しました'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @task = Task.find_by(id: params[:id])
    if @task.update(task_params)
      flash[:notice]='タスクの編集が完了しました'
      redirect_to root_path
    else
      flash.now[:alert]='タスクの編集に失敗しました'
      render 'edit', status: :unprocessable_entity
    end
  end

    private
      def task_params
        params.require(:task).permit(:title, :body)
      end

      def set_task
        @task = Task.find(params[:id])
      end
end
