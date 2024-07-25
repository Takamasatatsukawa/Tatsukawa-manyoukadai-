module Admin
    class UsersController < ApplicationController
      before_action :require_login
      before_action :require_admin
      before_action :set_user, only: [:show, :edit, :update, :destroy]
  
      def index
        @users = User.includes(:tasks)  # includes を使用して N+1 クエリを防ぐ
      end
  
      def new
        @user = User.new
      end
  
      def create
        @user = User.new(user_params)
        if @user.save
          redirect_to admin_users_path, notice: 'ユーザを登録しました'
        else
          render :new
        end
      end
  
      def show
      end
  
      def edit
      end
  
      def update
        @user = User.find(params[:id])
        if @user.update(user_params)
          redirect_to admin_users_path, notice: 'ユーザを更新しました'
        else
          render :edit
        end
      end
  
      def destroy
        if @user.destroy
           redirect_to admin_users_path, notice: 'ユーザを削除しました'
        else
          #  redirect_to admin_users_path, alert: @user.errors.full_messages.to_sentence
          flash[:alert] = @user.errors.full_messages.join(', ')
          redirect_to admin_users_path
        end
      end
  
      private
  
      def set_user
        @user = User.find(params[:id])
      end
  
      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
      end
  
      def require_admin
        unless current_user&.admin?
          flash[:alert] = '管理者以外アクセスできません'
          redirect_to tasks_path
        end
      end
    end
  end
  