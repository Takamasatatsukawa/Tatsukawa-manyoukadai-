class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :require_logout, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path(@user), notice: 'アカウントを登録しました'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'アカウントを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'アカウントが削除されました'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    unless current_user?(@user)
      flash[:notice] = "アクセス権限がありません"
      redirect_to(tasks_path)
    end
  end

  def current_user?(user)
    user == current_user
  end


  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
