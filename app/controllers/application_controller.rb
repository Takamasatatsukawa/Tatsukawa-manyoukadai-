class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?
    before_action :require_login
    

    private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  
    def logged_in?
      !!current_user
    end

    def require_login
        unless logged_in?
          flash[:alert] = "ログインしてください"
          redirect_to new_session_path
        end
      end

    def require_logout
        if logged_in?
          flash[:alert] = "ログアウトしてください"
          redirect_to tasks_path
        end
    end
    
      def require_user
      unless logged_in?
      flash[:notice] = "ログインしてください"
      redirect_to new_session_path
    end
  end
end
