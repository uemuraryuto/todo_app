class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice]='カテゴリーの登録が完了しました'
      redirect_to categories_path
    else
      flash.now[:alert]='カテゴリーの登録に失敗しました'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice]='カテゴリーの編集が完了しました'
      redirect_to categories_path
    else
      flash.now[:alert]='カテゴリーの編集に失敗しました'
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      flash[:notice]='カテゴリーを削除しました'
      redirect_to categories_path
    else
      flash.now[:notice]='カテゴリーの削除に失敗しました'
      render 'show'
    end
  end

    private
      def category_params
        params.require(:category).permit(:title)
      end

      def set_category
        @category = Category.find(params[:id])
      end
end
